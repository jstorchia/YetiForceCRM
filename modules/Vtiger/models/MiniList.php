<?php
/* +***********************************************************************************
 * The contents of this file are subject to the vtiger CRM Public License Version 1.0
 * ("License"); You may not use this file except in compliance with the License
 * The Original Code is:  vtiger CRM Open Source
 * The Initial Developer of the Original Code is vtiger.
 * Portions created by vtiger are Copyright (C) vtiger.
 * All Rights Reserved.
 * Contributor(s): YetiForce.com
 * *********************************************************************************** */

class Vtiger_MiniList_Model extends Vtiger_Widget_Model
{

	protected $widgetModel;
	protected $extraData;
	protected $listviewController;
	protected $queryGenerator;
	protected $listviewHeaders;
	protected $listviewRecords;
	protected $targetModuleModel;

	public function setWidgetModel($widgetModel)
	{
		$this->widgetModel = $widgetModel;
		$this->extraData = $this->widgetModel->get('data');

		// Decode data if not done already.
		if (is_string($this->extraData)) {
			$this->extraData = \includes\utils\Json::decode(decode_html($this->extraData));
		}
		if ($this->extraData == NULL) {
			throw new Exception("Invalid data");
		}
	}

	public function getTargetModule()
	{
		return $this->extraData['module'];
	}

	public function getTargetFields()
	{
		$fields = $this->extraData['fields'];
		if (!in_array("id", $fields))
			$fields[] = "id";
		return $fields;
	}

	public function getTargetModuleModel()
	{
		if (!$this->targetModuleModel) {
			$this->targetModuleModel = Vtiger_Module_Model::getInstance($this->getTargetModule());
		}
		return $this->targetModuleModel;
	}

	protected function initListViewController()
	{
		if (!$this->listviewController) {
			$currentUserModel = Users_Record_Model::getCurrentUserModel();
			$db = PearDatabase::getInstance();

			$filterid = $this->widgetModel->get('filterid');
			$this->queryGenerator = new QueryGenerator($this->getTargetModule(), $currentUserModel);
			$this->queryGenerator->initForCustomViewById($filterid);
			$this->queryGenerator->setFields($this->getTargetFields());

			if (!$this->listviewController) {
				$this->listviewController = new ListViewController($db, $currentUserModel, $this->queryGenerator);
			}

			$this->listviewHeaders = $this->listviewRecords = NULL;
		}
	}

	public function getTitle($prefix = '')
	{
		$this->initListViewController();

		$db = PearDatabase::getInstance();

		$suffix = '';
		$customviewrs = $db->pquery('SELECT viewname FROM vtiger_customview WHERE cvid=?', array($this->widgetModel->get('filterid')));
		if ($db->num_rows($customviewrs)) {
			$customview = $db->fetch_array($customviewrs);
			$suffix = ' - ' . vtranslate($customview['viewname'], $this->getTargetModule());
		}
		return $prefix . vtranslate($this->getTargetModuleModel()->label, $this->getTargetModule()) . $suffix;
	}

	public function getHeaders()
	{
		$this->initListViewController();

		if (!$this->listviewHeaders) {
			$headerFieldModels = [];
			foreach ($this->listviewController->getListViewHeaderFields() as $fieldName => $webserviceField) {
				$fieldObj = vtlib\Field::getInstance($webserviceField->getFieldId());
				$headerFieldModels[$fieldName] = Vtiger_Field_Model::getInstanceFromFieldObject($fieldObj);
			}
			$this->listviewHeaders = $headerFieldModels;
		}

		return $this->listviewHeaders;
	}

	public function getHeaderCount()
	{
		return count($this->getHeaders());
	}

	public function getRecordLimit()
	{
		return $this->widgetModel->get('limit');
		;
	}

	public function getRecords($user)
	{
		$ownerSql = '';
		$this->initListViewController();
		if (!$user) {
			$currenUserModel = Users_Record_Model::getCurrentUserModel();
			$user = $currenUserModel->getId();
		} else if ($user === 'all') {
			$user = '';
		}
		$params = [];
		if (!empty($user)) {
			$ownerSql = ' AND vtiger_crmentity.smownerid = ? ';
			$params[] = $user;
		}
		if (!$this->listviewRecords) {
			$db = PearDatabase::getInstance();

			$query = $this->queryGenerator->getQuery() . $ownerSql;
			$query .= sprintf(' ORDER BY vtiger_crmentity.modifiedtime DESC LIMIT 0,%d', $this->getRecordLimit());
			$query = substr($query, 6);
			$query = sprintf('SELECT vtiger_crmentity.crmid as id, %s', $query);
			$result = $db->pquery($query, $params);

			$targetModuleName = $this->getTargetModule();
			$targetModuleFocus = CRMEntity::getInstance($targetModuleName);

			$entries = $this->listviewController->getListViewRecords($targetModuleFocus, $targetModuleName, $result);

			$this->listviewRecords = [];
			$index = 0;
			foreach ($entries as $id => $record) {
				$rawData = $db->query_result_rowdata($result, $index++);
				$record['id'] = $id;
				$this->listviewRecords[$id] = $this->getTargetModuleModel()->getRecordFromArray($record, $rawData);
			}
		}

		return $this->listviewRecords;
	}

	public function getKeyMetricsWithCount($user = false)
	{
		$db = PearDatabase::getInstance();
		$currenUserModel = Users_Record_Model::getCurrentUserModel();
		if (!$user) {
			$user = $currenUserModel->getId();
		} else if ($user === 'all') {
			$user = '';
		}
		require_once 'modules/CustomView/ListViewTop.php';
		$metriclists = getMetricList([$this->widgetModel->get('filterid')]);

		if (!empty($metriclists)) {
			$metriclist = current($metriclists);
			$queryGenerator = new QueryGenerator($metriclist['module'], $currenUserModel);
			$queryGenerator->initForCustomViewById($metriclist['id']);
			if ($metriclist['module'] == "Calendar") {
				// For calendar we need to eliminate emails or else it will break in status empty condition
				$queryGenerator->addCondition('activitytype', "Emails", 'n', QueryGenerator::$AND);
			}
			if (!empty($user)) {
				$queryGenerator->addCondition('assigned_user_id', $user, 'om', QueryGenerator::$AND);
			}
			$metricsql = $queryGenerator->getQuery();
			$metricresult = $db->query(vtlib\Functions::mkCountQuery($metricsql));
			if ($metricresult) {
				$rowcount = $db->fetch_array($metricresult);
				return $rowcount['count'];
			}
		}
		return false;
	}

	public function getListViewURL($user = false)
	{
		$url = 'index.php?module=' . $this->getTargetModule() . '&view=List&viewname=' . $this->widgetModel->get('filterid');
		if (!$user) {
			$currenUserModel = Users_Record_Model::getCurrentUserModel();
			$userName = $currenUserModel->getName();
		} else if ($user && $user !== 'all') {
			$userName = \includes\fields\Owner::getUserLabel($user);
		}
		return empty($userName) ? $url : $url .= '&search_params=[[["assigned_user_id","c","' . $userName . '"]]]';
	}
}
