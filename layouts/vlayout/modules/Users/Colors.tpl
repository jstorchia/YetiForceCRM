{*<!--
/*+***********************************************************************************************************************************
 * The contents of this file are subject to the YetiForce Public License Version 1.1 (the "License"); you may not use this file except
 * in compliance with the License.
 * Software distributed under the License is distributed on an "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or implied.
 * See the License for the specific language governing rights and limitations under the License.
 * The Original Code is YetiForce.
 * The Initial Developer of the Original Code is YetiForce. Portions created by YetiForce are Copyright (C) www.yetiforce.com. 
 * All Rights Reserved.
 *************************************************************************************************************************************/
-->*}
{strip}
<div class="container-fluid UserColors">
	<div class="widget_header row-fluid">
		<div class="span10"><h3>{vtranslate('LBL_COLORS', $QUALIFIED_MODULE)}</h3>{vtranslate('LBL_COLORS_DESCRIPTION', $QUALIFIED_MODULE)}</div>
		<div class="span2"></div>
	</div>
	<hr>
	<div class="row-fluid">
		<div class="contents tabbable">
			<ul class="nav nav-tabs layoutTabs massEditTabs">
				<li class="active"><a data-toggle="tab" href="#userColors"><strong>{vtranslate('LBL_USERS_COLORS', $QUALIFIED_MODULE)}</strong></a></li>
				<li ><a data-toggle="tab" href="#groupsColors"><strong>{vtranslate('LBL_GROUPS_COLORS', $QUALIFIED_MODULE)}</strong></a></li>
			</ul>
			<div class="tab-content layoutContent" style="padding-top: 10px;">
				<div class="tab-pane active" id="userColors">
					<table class="table table-bordered table-condensed listViewEntriesTable">
						<thead>
							<tr class="blockHeader">
								<th><strong>{vtranslate('First Name',$QUALIFIED_MODULE)}</strong></th>
								<th><strong>{vtranslate('Last Name',$QUALIFIED_MODULE)}</strong></th>
								<th><strong>{vtranslate('LBL_COLOR',$QUALIFIED_MODULE)}</strong></th>
								<th><strong>{vtranslate('LBL_TOOLS',$QUALIFIED_MODULE)}</strong></th>
							</tr>
						</thead>
						<tbody>
							
							{foreach from=Users_Colors_Model::getUserColors() item=item key=key}
								<tr data-id="{$item.id}" data-color="{$item.color}">
									<td>{$item.first}</td>
									<td>{$item.last}</td>
									<td class="calendarColor" style="background: {$item.color};"></td>
									<td>
										<button class="btn updateColor" data-metod="updateUserColor">{vtranslate('LBL_UPDATE_COLOR',$QUALIFIED_MODULE)}</button>&ensp;
										<button class="btn generateColor" data-metod="generateUserColor">{vtranslate('LBL_GENERATE_COLOR',$QUALIFIED_MODULE)}</button>
									</td>
								</tr>
							{/foreach}
						</tbody>
					</table>
				</div>
				<div class="tab-pane" id="groupsColors">
					<table class="table table-bordered table-condensed listViewEntriesTable">
						<thead>
							<tr class="blockHeader">
								<th><strong>{vtranslate('LBL_GROUP_NAME',$QUALIFIED_MODULE)}</strong></th>
								<th><strong>{vtranslate('LBL_COLOR',$QUALIFIED_MODULE)}</strong></th>
								<th><strong>{vtranslate('LBL_TOOLS',$QUALIFIED_MODULE)}</strong></th>
							</tr>
						</thead>
						<tbody>
							{foreach from=Users_Colors_Model::getGroupColors() item=item key=key}
								<tr data-id="{$item.id}" data-color="{$item.color}">
									<td>{$item.groupname}</td>
									<td class="calendarColor" style="background: {$item.color};"></td>
									<td>
										<button class="btn updateColor" data-metod="updateGroupColor">{vtranslate('LBL_UPDATE_COLOR',$QUALIFIED_MODULE)}</button>&ensp;
										<button class="btn generateColor" data-metod="generateGroupColor">{vtranslate('LBL_GENERATE_COLOR',$QUALIFIED_MODULE)}</button>
									</td>
								</tr>
							{/foreach}
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>
	<div class="clearfix"></div>
	<div class="modal editColorContainer hide">
		<div class="modal-header contentsBackground">
			<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
			<h3>{vtranslate('LBL_EDIT_COLOR', $QUALIFIED_MODULE)}</h3>
		</div>
		<div class="modal-body">
			<form class="form-horizontal">
				<input type="hidden" class="selectedColor" value="" />
				<div class="control-group">
					<label class="control-label">{vtranslate('LBL_SELECT_COLOR', $QUALIFIED_MODULE)}</label>
					<div class="controls">
						<p class="calendarColorPicker"></p>
					</div>
				</div>
			</form>
		</div>
		{include file='ModalFooter.tpl'|@vtemplate_path:$MODULE}
	</div>
{/strip}