<?php
/**
 * Multi reference value cron
 * @package YetiForce.Cron
 * @license licenses/License.html
 * @author Mariusz Krzaczkowski <m.krzaczkowski@yetiforce.com>
 */
$adb = PearDatabase::getInstance();
$limit = AppConfig::performance('CRON_MAX_NUMERS_RECORD_PRIVILEGES_UPDATER');

$i = 0;
$result = $adb->query('SELECT * FROM u_yf_crmentity_search_label WHERE `userid` = \'\'');
while ($row = $adb->getRow($result)) {
	\includes\GlobalPrivileges::updateGlobalSearch($row['crmid'], $row['setype']);
	$i++;
	if ($i == $limit) {
		return;
	}
}
$resultUpdater = $adb->query('SELECT * FROM s_yf_privileges_updater ORDER BY `priority` DESC');
while ($row = $adb->getRow($resultUpdater)) {
	$crmid = $row['crmid'];
	if ($row['type'] == 0) {
		\includes\GlobalPrivileges::updateGlobalSearch($crmid, $row['module']);
		$i++;
		if ($i == $limit) {
			return;
		}
	} else {
		$resultCrm = $adb->pquery('SELECT crmid FROM vtiger_crmentity WHERE setype =? AND crmid > ?', [$row['module'], $crmid]);
		while ($rowCrm = $adb->getRow($resultCrm)) {
			\includes\GlobalPrivileges::updateGlobalSearch($rowCrm['crmid'], $row['module']);
			$affected = $adb->update('s_yf_privileges_updater', ['crmid' => $rowCrm['crmid']], 'module =? AND type =? AND crmid =?', [$row['module'], 1, $crmid]);
			$crmid = $rowCrm['crmid'];
			$i++;
			if ($i == $limit || $affected == 0) {
				return;
			}
		}
	}
	$adb->delete('s_yf_privileges_updater', 'module =? AND type =? AND crmid =?', [$row['module'], $row['type'], $crmid]);
}

