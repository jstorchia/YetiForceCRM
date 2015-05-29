{*<!--
/*********************************************************************************
  ** The contents of this file are subject to the vtiger CRM Public License Version 1.0
   * ("License"); You may not use this file except in compliance with the License
   * The Original Code is:  vtiger CRM Open Source
   * The Initial Developer of the Original Code is vtiger.
   * Portions created by vtiger are Copyright (C) vtiger.
   * All Rights Reserved.
  *
 ********************************************************************************/
-->*}
<div style='padding:5px'>
{if count($MODELS) > 0}
	<div class='row'>
		<div class='col-md-12'>
			<div class='row'>
				<div class='col-md-4'>
					<strong>{vtranslate('Potential Name', $MODULE_NAME)}</strong>
				</div>
				<div class='col-md-4'>
					<strong>{vtranslate('Amount', $MODULE_NAME)}</strong>
				</div>
				<div class='col-md-4'>
					<strong>{vtranslate('Related To', $MODULE_NAME)}</strong>
				</div>
			</div>
		</div>
		<hr>
		{foreach item=MODEL from=$MODELS}
		<div class='row'>
			<div class='col-md-4'>
				<a href="{$MODEL->getDetailViewUrl()}">{$MODEL->getName()}</a>
			</div>
			<div class='col-md-4'>
				{$MODEL->getDisplayValue('sum_invoices')}
			</div>
			<div class='col-md-4'>
				{$MODEL->getDisplayValue('related_to')}
			</div>
		</div>
		{/foreach}
	</div>
{else}
	<span class="noDataMsg">
		{vtranslate('LBL_NO_RECORDS_MATCHED_THIS_CRITERIA')}
	</span>
{/if}
</div>