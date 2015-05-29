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
{strip}
	<span class="span0 spanModuleIcon moduleIcon{$MODULE_NAME}">
		<span class="moduleIcon">
	        {assign var=IMAGE_DETAILS value=$RECORD->getImageDetails()}
			{foreach key=ITER item=IMAGE_INFO from=$IMAGE_DETAILS}
				{if !empty($IMAGE_INFO.path)}
					<img src="{$IMAGE_INFO.path}_{$IMAGE_INFO.orgname}" alt="{$IMAGE_INFO.orgname}" title="{$IMAGE_INFO.orgname}" width="65" height="80" align="left"><br>
				{else}
					<img src="{vimage_path('Contacts48.png')}" class="summaryImg" alt="{vtranslate($MODULE, $MODULE)}"/>
				{/if}
			{/foreach}
	        {if empty($IMAGE_DETAILS)}
	            <img src="{vimage_path('Contacts48.png')}" class="summaryImg" alt="{vtranslate($MODULE, $MODULE)}"/>
	        {/if}
		</span>
	</span>
	<span class="col-md-8 margin0px">
		<span class="row">
			<h4 class="recordLabel pushDown" title="{$RECORD->getDisplayValue('salutationtype')}&nbsp;{$RECORD->getName()}"> &nbsp;
				{if $RECORD->getDisplayValue('salutationtype')}
                    <span class="salutation">{$RECORD->getDisplayValue('salutationtype')}</span>&nbsp;
                {/if}
                {assign var=COUNTER value=0}
                {foreach item=NAME_FIELD from=$MODULE_MODEL->getNameFields()}
                    {assign var=FIELD_MODEL value=$MODULE_MODEL->getField($NAME_FIELD)}
                    {if $FIELD_MODEL->getPermissions()}
                        <span class="moduleColor_{$MODULE_NAME} {$NAME_FIELD}">{$RECORD->get($NAME_FIELD)}</span>
                    {if $COUNTER eq 0 && ($RECORD->get($NAME_FIELD))}&nbsp;{assign var=COUNTER value=$COUNTER+1}{/if}
                {/if}
            {/foreach}
			</h4>
		</span>
		<span class="row">
			{$RECORD->getDisplayValue('parent_id')}
			<span class="row">
				<span class="muted">
					{vtranslate('Assigned To',$MODULE_NAME)}: {$RECORD->getDisplayValue('assigned_user_id')}
					{if $RECORD->get('shownerid') != ''}
					<br/>{vtranslate('Share with users',$MODULE_NAME)} {$RECORD->getDisplayValue('shownerid')}
					{/if}
				</span>
			</span>
		</span>
	</span>
{/strip}