{*<!-- {[The file is published on the basis of YetiForce Public License that can be found in the following directory: licenses/License.html]} --!>*}
{strip}
	{assign var=FIELD_NAME value=$FIELD_MODEL->get('name')}
	{assign var="REFERENCE_LIST" value=$FIELD_MODEL->getReferenceList()}
	{assign var="REFERENCE_LIST_COUNT" value=count($REFERENCE_LIST)}
	{assign var="FIELD_INFO" value=Vtiger_Util_Helper::toSafeHTML(\includes\utils\Json::encode($FIELD_MODEL->getFieldInfo()))}
	{assign var="SPECIAL_VALIDATOR" value=$FIELD_MODEL->getValidator()}
	{assign var="UITYPE_MODEL" value=$FIELD_MODEL->getUITypeModel()}
	{if {$REFERENCE_LIST_COUNT} eq 1}
		<input name="popupReferenceModule" type="hidden" data-multi-reference="0" title="{reset($REFERENCE_LIST)}" value="{reset($REFERENCE_LIST)}" />
	{/if}
	{assign var="DISPLAYID" value=$FIELD_MODEL->get('fieldvalue')}
	{if {$REFERENCE_LIST_COUNT} gt 1}
		{assign var="REFERENCED_MODULE_STRUCT" value=$UITYPE_MODEL->getReferenceModule($DISPLAYID)}
		{if !empty($REFERENCED_MODULE_STRUCT)}
			{assign var="REFERENCED_MODULE_NAME" value=$REFERENCED_MODULE_STRUCT->get('name')}
		{/if}
		{if in_array($REFERENCED_MODULE_NAME, $REFERENCE_LIST)}
			<input name="popupReferenceModule" type="hidden" data-multi-reference="1" value="{$REFERENCED_MODULE_NAME}" />
		{else}
			<input name="popupReferenceModule" type="hidden" data-multi-reference="1" value="{$REFERENCE_LIST[0]}" />
		{/if}
	{/if}
	<input name="{$FIELD_MODEL->getFieldName()}" type="hidden" value="{$FIELD_MODEL->get('fieldvalue')}" title="{$FIELD_MODEL->get('fieldvalue')}" class="sourceField" data-fieldtype="{$FIELD_MODEL->getFieldDataType()}" data-displayvalue="{$FIELD_MODEL->getEditViewDisplayValue($FIELD_MODEL->get('fieldvalue'))}" data-fieldinfo='{$FIELD_INFO}' {if $FIELD_MODEL->isEditableReadOnly()}readonly="readonly"{/if} />
	<div class="input-group referenceGroup">
		{if $REFERENCE_LIST_COUNT > 1}
			<div class="input-group-addon noSpaces referenceModulesListGroup">
				<select id="{$MODULE}_editView_fieldName_{$FIELD_MODEL->getName()}_dropDown" class="referenceModulesList" title="{vtranslate('LBL_RELATED_MODULE_TYPE')}" required="required">
					{foreach key=index item=REFERENCE from=$REFERENCE_LIST}
						{assign var=REFERENCE_MODULE_MODEL value=Vtiger_Module_Model::getInstance($REFERENCE)}
						<option value="{$REFERENCE}" title="{vtranslate($REFERENCE, $REFERENCE)}" data-is-quickcreate="{$REFERENCE_MODULE_MODEL->isQuickCreateSupported()}" data-parent="{$UITYPE_MODEL->getParentModule($REFERENCE)}" {if $REFERENCE eq $REFERENCED_MODULE_NAME} selected {/if}>{vtranslate($REFERENCE, $REFERENCE)}</option>
					{/foreach}
				</select>
			</div>
		{/if}
		<input id="{$FIELD_NAME}_display" name="{$FIELD_MODEL->getFieldName()}_display" type="text" title="{Vtiger_Util_Helper::toSafeHTML($FIELD_MODEL->getEditViewDisplayValue($DISPLAYID))}" class="marginLeftZero form-control autoComplete" {if !empty($DISPLAYID)}readonly="true"{/if}
			   value="{Vtiger_Util_Helper::toSafeHTML($FIELD_MODEL->getEditViewDisplayValue($DISPLAYID))}" data-validation-engine="validate[{if $FIELD_MODEL->isMandatory() eq true} required,{/if}funcCall[Vtiger_Base_Validator_Js.invokeValidation]]"
			   data-fieldinfo='{$FIELD_INFO}' {if $FIELD_MODEL->get('displaytype') != 10}placeholder="{vtranslate('LBL_TYPE_SEARCH',$MODULE)}"{/if}
			   {if !empty($SPECIAL_VALIDATOR)}data-validator='{\includes\utils\Json::encode($SPECIAL_VALIDATOR)}'{/if} {if $FIELD_MODEL->isEditableReadOnly()}readonly="readonly"{/if}/>
		<span class="input-group-btn cursorPointer">
			{if $FIELD_MODEL->get('displaytype') != 10}
				<button class="btn btn-default clearReferenceSelection" type="button">
					<span id="{$MODULE}_editView_fieldName_{$FIELD_NAME}_clear" class="glyphicon glyphicon-remove-sign" title="{vtranslate('LBL_CLEAR', $MODULE)}"></span>
				</button>
			{/if}
			{if $FIELD_MODEL->get('displaytype') != 10}
				<button class="btn btn-default relatedPopup" type="button">
					<span id="{$MODULE}_editView_fieldName_{$FIELD_NAME}_select" class="glyphicon glyphicon-search" title="{vtranslate('LBL_SELECT', $MODULE)}" ></span>
				</button>
			{/if}
			{assign var=REFERENCE_MODULE_MODEL value=Vtiger_Module_Model::getInstance($REFERENCE_LIST[0])}
			<!-- Show the add button only if it is edit view  -->
			{if (($VIEW eq 'Edit') or ($MODULE_NAME eq 'Webforms')) && $REFERENCE_MODULE_MODEL->isQuickCreateSupported() && $FIELD_MODEL->get('displaytype') != 10}
				<button class="btn btn-default createReferenceRecord" type="button">
					<span id="{$MODULE}_editView_fieldName_{$FIELD_NAME}_create" class='glyphicon glyphicon-plus' title="{vtranslate('LBL_CREATE', $MODULE)}"></span>
				</button>
			{/if}
		</span>
	</div>
{/strip}
