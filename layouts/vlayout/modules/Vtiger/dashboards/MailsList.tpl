﻿<div class="dashboardWidgetHeader">
	{foreach key=index item=cssModel from=$STYLES}
		<link rel="{$cssModel->getRel()}" href="{$cssModel->getHref()}" type="{$cssModel->getType()}" media="{$cssModel->getMedia()}" />
	{/foreach}
	{foreach key=index item=jsModel from=$SCRIPTS}
		<script type="{$jsModel->getType()}" src="{$jsModel->getSrc()}"></script>
	{/foreach}
	<div class="row">
		<div class="col-md-8">
			<div class="dashboardTitle" title="{vtranslate($WIDGET->getTitle(), 'OSSMail')}"><strong>&nbsp;&nbsp;{vtranslate($WIDGET->getTitle(),'OSSMail')}</strong></div>
		</div>
		<div class="col-md-4">
			<div class="box pull-right">
				{if !$WIDGET->isDefault()}
					<a name="dclose" class="btn btn-xs btn-default widget" data-url="{$WIDGET->getDeleteUrl()}">
						<span class="glyphicon glyphicon-remove" hspace="2" border="0" align="absmiddle" title="{vtranslate('LBL_REMOVE')}" alt="{vtranslate('LBL_REMOVE')}"></span>
					</a>
				{/if}
			</div>
		</div>
	</div>
	<hr class="widgetHr"/>
	<div class="row" >
		<div class="col-md-12">
			<div class="pull-right">
				<select class="mailUserList" id="mailUserList" title="{vtranslate('LBL_MAIL_USERS_LIST')}" name="type" style='width:200px;margin-bottom:0px'>
					{if count($ACCOUNTSLIST) eq 0}
						<option value="-">{vtranslate('--None--', $MODULE_NAME)}</option>
					{else}
						{foreach from=$ACCOUNTSLIST item=item key=key}
							<option title="{$item['username']}" value="{$item['user_id']}" {if $USER == $item['user_id']}selected{/if}>{$item['username']}</option>
						{/foreach}
					{/if}
				</select>
			</div>
		</div>
	</div>
</div>
<div class="dashboardWidgetContent">
	{include file="dashboards/MailsListContents.tpl"|@vtemplate_path:$MODULE_NAME}
</div>
