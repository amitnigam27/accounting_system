<%@ page contentType="text/html;charset=UTF-8" %>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1"/>
		<meta name="layout" content="main"/>
		<link rel="shortcut icon" href="${resource(dir: 'images', file: 'favicon.ico')}" type="image/x-icon"/>
		<title>Company</title>
		<style>
			.mb{height:35px;}
			.view{
			    pointer-events: none;
			    cursor: not-allowed;
			    opacity: 1.0;
			}
			.add-more {
				float: right;
				margin: 3px 12px 0 0;
				cursor:pointer;
			}
			.fa-trash {
				cursor:pointer;
			}
			.isError{
				background : #f5e6e6 !important;
			}
			#add{
				margin-right:0px!important;
			}
			.ui-widget-header .ui-state-default{
				background-color: #f4f4f4 !important;
			}
			.ui-widget-header .ui-state-active{
				background-color:white !important;
			}
		</style>
	</head>
	<body>
	
	<pui:menu type="page" objectType="-1" context="accounting" appCode="PPM" title="Company" model=""/>
		<div class="mb" style="height:50px;"></div>
		<div class="clear"></div>
		
		<g:if test="${isReadOnly==false}">
		<div style="width:50%; padding: 0 0 0 2%;" class="left" >
				<button type="button" id="addCompanyBtnId"
					class="btn pui-primary btn-sm createCompany" style="margin-left:-3%;"
					title="${message(code:'com.prolifics.ppmweb.company.company.addCompany')}">
					<em class="puicon1-list-add"></em>
					<g:message code="com.prolifics.ppmweb.company.company.addCompany" />
				</button>
		</div>
		</g:if>
		
		<div class="mb" style="height:10px;"></div>
		
	  	<div class="col-md-12" style="width:50%;">
			<table class="table table-striped table-bordered table-hover pui-table-grid display dataTable no-footer" id="companyTable" style="margin: 0px;  word-wrap: break-word;">
				<thead>
					<tr>
						<th width="15%"><g:message code="com.prolifics.ppmweb.company.company.sno" /></th>
					    <th width="50%"><g:message code="com.prolifics.ppmweb.company.company.companyName" /></th>
					    <th width="25"><g:message code="com.prolifics.ppmweb.company.company.currency" /></th>
						<th width="10%"><g:message code="com.prolifics.ppmweb.company.company.action" /></th>
					</tr>
				</thead>
				<tbody>
					<g:if test="${cmpnies}">
						<g:set var="sno" value="${1}"></g:set>
						<g:each in="${cmpnies}" var="company">
							<tr class="pui-altcolor">
								<td style="text-align: center;">${sno++}</td>
								<td>${company.companyName}</td>
								<td>${company.currencyId.description}</td>
								<td class="text-center">
									<a href= "javascript:viewCompany(${company?.id});" class="viewCompany ui-pg-button ui-pg-div"><i style="opacity:0.5;height:18px;font-size:15px; color:black;" class="fa fa-eye"></i></a>
									<g:if test="${isReadOnly==false}">
										<a href= "javascript:editCompany(${company?.id});" class="editCompany ui-pg-button ui-pg-div"><i style="height:13px;" class="ui-icon ui-icon-pencil"></i></a>
									</g:if>
								</td>				
							</tr>
						</g:each>
					</g:if>
					<g:else>
						<tr>
							<td colspan=12 align="center"> <div style="color: #555;">No Records To View</div> </td>
						</tr>
					</g:else>
				</tbody>
			</table>
	  	</div>
	  		
	  	<div id="companyDetails"
			title="${message(code:'com.prolifics.ppmweb.company.company.companyDetails')}">
			<div>
				<div id="companyDetailErr"></div>
				<g:form class="form-vertical" name="createCompany" enctype="multipart/form-data">
					<div class="alert alert-danger saveErr clear">
						<strong> <em class="icon" data-icon=""></em> <g:message code="com.prolifics.ppmweb.common.error.msg" /> </strong>
						<g:message code="com.prolifics.ppmweb.common.error.msgTxt" />
						<br>
					</div>
	
					<div class="form-group" id="companyGroup">
						<div class="pui-require" id="companyName">
							<label class="col-md-3 control-label no-padding" for="CompanyNqme"><g:message
									code="com.prolifics.ppmweb.company.company.companyName" /></label> <span
								class="col-md-1">:</span> <span class="col-md-4">
								<g:textField name="companyName" class="empty col-md-12 pui-input companyName" />
							</span>
							<input id="isMasterCmpny" type="checkbox" name="isMasterCmpny" style="margin-left: 10px;"/>
							<label class="col-md-3 no-padding">Master Company</label>
						</div>
						<div class="mb"></div>
						<div  class="pui-require" id="companyId">
							<label class="col-md-3  control-label no-padding" for="CompanyId"><g:message
									code="com.prolifics.ppmweb.company.company.companyId" /></label> <span
								class="col-md-1">:</span> <span class="col-md-4">
								<g:textField name="companyId" class="empty col-md-12 pui-input companyId" />
							</span>
						</div>
						<div class="mb"></div>
						<div  class="pui-require" id="currencyId">
							<label class="col-md-3 control-label no-padding" for="currencyId"><g:message
									code="com.prolifics.ppmweb.company.company.currency" /></label>
							<span class="col-md-1">:</span> <span class="col-md-4"> <g:select
									name="currency" id="currencySourceId" from="${currencySource}"
									optionKey="id" optionValue="description"
									noSelection="${['': message(code:'com.prolifics.ppmweb.common.text.plsSel')]}"
									class="col-md-12 pui-input currencySourceId"/>
							</span>
						</div>
						<div id='confirm' >Discard changes?</div>
				</div>
				<div class="mb"></div>
				<div id="tabs">
					  <ul style="background-color: white !important;">
					    <li style="border-bottom: 1px solid #fff !important;" class="thisCompany"><a href="#tabs-1" class="accType" data-val="current">This Company G/L Accounts</a></li>
					    <li style="border-bottom: 1px solid #fff !important;" class="otherCompany"><a href="#tabs-2" class="accType" data-val="other">Other Company G/L Accounts</a></li> 
					    <button type="button" id="add"
										class="btn pui-primary btn-sm icon add-more" stlye="margin-right: 0px !important;"title="add">
										<i class="fa fa-plus"></i>
										<g:message code="com.prolifics.ppmweb.project.create.add" />
									</button>
					  </ul>
					  
					  
					  <div id="tabs-1">	
							<div class="form-group" id="CurrentCompanyAccountingGroup">
							<table class="table table-striped table-bordered table-hover pui-table-grid display dataTable no-footer"
										 style="margin: 0px;  word-wrap: break-word;">
								<thead>
									<tr>
										<td></td>
										<td class="text-center" colspan="3" ><b>Intercompany Accounts</b></td>
									</tr>
									<tr>
										<td class="center"><b>Company Name</b></td>
										<td class="center"><b>Cost Center</b></td>
										<td class="center"><b>G/L Account</b></td>
										<td class="delGLAcc center">&nbsp;</td>
									</tr>	
								</thead>
								<tbody class="currentCompGLAccount"></tbody>
							</table> 
							</div>		 
				  	  </div>
					  <div id="tabs-2">
					  		<div class="form-group" id="OtherCompanyAccountingGroup">
								<table class="table table-striped table-bordered table-hover pui-table-grid display dataTable no-footer"
											  style="margin: 0px;  word-wrap: break-word;">
									<thead>
										<tr>
											<td></td>
											<td class="text-center" colspan="3" ><b>Intercompany Accounts</b></td>
										</tr>
										<tr>
											<td class="center"><b>Company Name</b></td>
											<td class="center"><b>Cost Center</b></td>
											<td class="center"><b>G/L Account</b></td>
										</tr>	
									</thead>
									<tbody class="otherCompGLAccount"></tbody>
								</table> 
							</div>		
					  </div>
				</div>
				 
				 	<div class="clear" style="height:10px;"></div>
					<div class=" center"> 
						<button type="button" id="save" class="btn pui-primary btn-sm"
							title="save">
							<em class="puicon-floppy19"></em>
							<g:message
								code="com.prolifics.ppmweb.projectIssue.viewPrjIssues.save" />
						</button> 
					 </div>	 
				</g:form>
				
			</div>
		</div>
		
		<div class="clear">
			  
			 <table id="glAccSct">
				<tbody id="glAccSctTbl">
					 <tr id="rowIndex_INDEX_">
						<td id="dialogTableCompanyName_INDEX_">
							<g:select name="dialogTable_TYPE_Companies_INDEX_" from="${cmpnies}"
								optionKey="id"  id="dialogTableCompanies_INDEX_"  optionValue="companyName" class="comps"
								noSelection="${[null: "${message(code:"com.prolifics.ppmweb.common.plsSelect")}"]}"
								class="col-xs-12 pui-input pui-require account" onChange = "isChanged(event)" notEqual="null" /></td>
						<td><g:textField name="costCenter" id="_TYPE_costCenter_INDEX_" onChange = "isChanged(event)" onkeypress = "costCenterKeyPress(event)" class="empty col-md-12 pui-input costCenter" /></td>
						<td><g:textField name="glAccount" id="_TYPE_glAccount_INDEX_" onChange = "isChanged(event)" onkeypress = "glAccountKeyPress(event)"	 class="empty col-md-12 pui-input glAccount" maxlength="8"/></td>
						<td onclick="deleteAccount(event)"><i class="fa fa-trash" id="_TYPE_delglAccount_INDEX_" aria-hidden="true"></i></td>
					</tr>	
				</tbody>
			</table>
			 
		</div>
		<div id="delAccDlg" title="${message(code:'com.prolifics.ppmweb.accounting.company.delete') }" style = "display: none;">
			<g:message code="com.prolifics.ppmweb.accounting.company.delete.delPromptMsg" />
		</div>
		<script type="text/javascript">
			var created ='';
			var form = $('#createCompany');
			var currentCompInc = 2;
			var compType = 'current';
			var accounts = [];
			var companyDtls = {}, oData = {};
			var editCompanyId = null;
			var isEdit = false, isAdd = false;
			var glAccType = "${com.prolifics.ppmweb.constant.Constants.LKP_TYPE_COMPANY_GL_ACC}";
			var otherAccType = "${com.prolifics.ppmweb.constant.Constants.LKP_TYPE_OTHER_COMPANY_GL_ACC}";
			var options ='', closeDlg = false;
			
			$(function() {
				$( "#tabs" ).tabs({
					 activate: function( event, ui ) {
						 	compType = $(ui.newTab).find('a').attr('data-val');
						 	
						 	if($(ui.newTab).hasClass('otherCompany')){
						 		$("#add").hide();
							}else{
								if(isEdit || isAdd)
									$("#add").show();
							}
						 }
				});
			});
		
			$(document).ready(function(){
				var companySize = "${cmpnies.size()}";  
				if(companySize != 0){
					$('#companyTable').DataTable({
						"iDisplayLength": 15,
					});
				}

				$("#companyGroup input,#companyGroup select").change(function(){
					$(this).addClass('isDirty');
				});

				$("#confirm").dialog({
					modal: true,
					autoOpen: false,
					title:'Confirmation',
					buttons: {
								"Yes": function() {
									$("#confirm").dialog( "close" );
									closeDlg = true;
									$("#companyDetails").dialog('close');
								},
								 "No": function() {
									$(this).dialog( "close" );
								 }
							},
					open:function(){
						$("#companyDetails").dialog( "instance" ).uiDialog.css('pointer-events','none');
					},
					close:function(){
						$("#companyDetails").dialog( "instance" ).uiDialog.css('pointer-events','');	
					}
				});
			});
			
			$("#companyDetails").dialog({
			    autoOpen: false,
			    modal: true,
			    width: 600,
				show : 'blind',
			    height: "auto",  
			    resizable: false,
			    open: function(){
			    			$('.isDirty').removeClass('isDirty');
			    		},
			    beforeClose: function( event, ui ) {
			    				if($('.isDirty').length > 0 && !closeDlg){
			    					$("#confirm").dialog('open');
			    					return false;
			    				} else{
			    					closeDlg = false;
			    					return true;
			    				}
			    			}
			});
		
			$('#save').click(function(){
				
				companyDtls = {}, accounts = [];
				
				companyDtls['id'] = editCompanyId;
				companyDtls['companyName'] = $(".companyName").val();
				companyDtls['companyId'] = $(".companyId").val();
				companyDtls['currencyId'] = $(".currencySourceId").val();
				companyDtls['isMasterCompany'] = $("#isMasterCmpny").is(":checked");
				
				saveAccountsObj('currentCompGLAccount', glAccType);
				saveAccountsObj('otherCompGLAccount', otherAccType);
				
				oData['companyDtls'] = companyDtls;
				oData['accounts'] = accounts;
				
				if($(".isError").length == 0){
					saveAjaxCall(oData); 
				} else{
					$('#pageMessage').hide();
					$("#companyDetailErr").attr('class', 'alert alert-danger collapse');	
					$("#companyDetailErr").show();
					$("#companyDetailErr").html('Please select the valid values for highlighted fields');
				}
			});
			
			function saveAccountsObj(acc, type){
				var tempAcc = [];
				
				$.each($("."+acc+" tr:not('.isDirty')"), function(key,val){
					tempAcc.push(parseInt($(val).find('td[accountId]').attr('accountId')));
				});
	
				$.each($("."+acc+" tr.isDirty"), function(key,val){
					var v = {};
					var account = typeof $(val).find('td select.account').val() == 'undefined' ? $(val).find('td[accountId]').attr('accountId') : $(val).find('td select.account').val();
					var costCenter = $(val).find('td input.costCenter').val();
					var glAcc = $(val).find('td input.glAccount').val();
					glAcc = (glAcc.trim() == '') ? 0 : glAcc;
					
					if(account != 'null'){
						if(acc == 'currentCompGLAccount'){
							if($.inArray(parseInt(account), tempAcc) != -1)
								$(this).find('td select.account').addClass('isError');
							else
								$(this).find('td select.account').removeClass('isError');
								
							tempAcc.push(parseInt(account));
							
							if(costCenter.trim() == '')
								$(this).find('td input.costCenter').addClass('isError');
							else
								$(this).find('td input.costCenter').removeClass('isError');
							if(glAcc.trim() == '')
								$(this).find('td input.glAccount').addClass('isError');
							else
								$(this).find('td input.glAccount').removeClass('isError');
						}
					} else{
						$(this).find('td select.account').addClass('isError');
					}
					
					v['accountId'] = account;
					v['accountType'] = type;
					v['costCenter'] = costCenter;
					v['glAcc'] = parseInt(glAcc);
					accounts.push(v); 
				});
			}
		
			$('#add').click(function(){
				if($(".currentCompGLAccount tr:first td").text() ==  "No Records To View")
					$(".currentCompGLAccount tr:first").remove();
					
				var docSctHtml =  $('#glAccSct #glAccSctTbl').html().replace(/INDEX_/g, currentCompInc);   
				docSctHtml =  docSctHtml.replace(/TYPE_/g, compType); 
				$('.'+compType+'CompGLAccount').append(docSctHtml);
				
				if(isEdit){
					$("."+compType+"CompGLAccount #dialogTableCompanies_"+currentCompInc+" option").remove();
					$("."+compType+"CompGLAccount #dialogTableCompanies_"+currentCompInc).append(options);
				}
				
				currentCompInc = currentCompInc+1;
				
			});
			
			$(document).on("change", "select.account", function(){
				if($(".otherCompGLAccount tr:first td").text() ==  "No Records To View")
					$(".otherCompGLAccount tr:first").remove();
					
				var rowIdx = $(this).closest('tr').attr('id');
				var accId = $(this).val();
				var accName = $(this).find('option:selected').text();
				
				if($(".otherCompGLAccount").find('tr#'+rowIdx).length == 0){
					var otherGLAccounts = [];
					
					accounts['rowIdx'] = rowIdx;
					accounts['id'] = 'event';
					accounts['costCenter'] = '';
					accounts['glAccount'] = '';
					accounts['companyGLAccount'] = {};
					accounts['companyGLAccount']['id'] = accId;
					accounts['companyGLAccount']['companyName'] = accName;
					accounts['source'] = {};
					accounts['source']['id'] = editCompanyId;
					
					otherGLAccounts.push(accounts);
					$(".otherCompGLAccount").append(formTable(otherGLAccounts, 'other'));
					$(".otherCompGLAccount tr#"+rowIdx).addClass('isDirty');
				} else{
					$(".otherCompGLAccount").find('tr#'+rowIdx+' td[accountid]').attr('accountid',accId);
					$(".otherCompGLAccount").find('tr#'+rowIdx+' td[accountid]').text(accName);
				}
			});
			
			$('.accType').click(function() {
				compType = $(this).attr('data-val'); 
			});
			
			function saveAjaxCall(saveObj) {
				$('#spinner').show();
				
				var url='<g:createLink controller="accounting" action="save"/>';
				
				$.ajax({
					url:url,
					type:'POST',
					data :  {saveObj:JSON.stringify(saveObj)},
					async:false,
					success:function (data) {
						$('#spinner').hide();
						(data.status == 'Success') ? window.location.replace(data.nextUrl) : $.fn.mapMessages(form, data);
						if(data.status == 'Failure'){
							$('#pageMessage').hide();
							$("#companyDetailErr").attr('class', 'alert alert-danger collapse');	
							$("#companyDetailErr").show();
							$("#companyDetailErr").html(data.pageErrorMessage);
						}
					}
				});
			}
			
			$("#addCompanyBtnId").click(function(){
				editCompanyId = null;
				isEdit = false;
				isAdd = true;
				$(".companyName,.companyId,.costCenter,.glAccount, #isMasterCmpny").attr("disabled",false);
				$(".currencySourceId").attr("disabled", false);
				$("#companyDetails").removeClass("view");
				$("#companyName,#companyId,#currencyId,#costCenter,#glAccount").removeClass('pui-error');
			   	$("#companyName,#companyId,#currencyId,#costCenter,#glAccount").attr('data-original-title','');
				$('.companyName').val('');
				$('.companyId').val('');
				$('.costCenter').val('');		
				$('.glAccount').val('');
				$("#isMasterCmpny").prop("checked", false);
				$("#companyDetailErr").hide();
				$('option').attr('selected', false);
				$("#save, #add").show();
				$('#companyDetails').dialog('open');
				$(".companyName,.companyId,.currencyId,.costCenter,.glAccount").addClass('pui-require');
				$(".otherCompGLAccount").html('<tr><td colspan="4" style="text-align:center">No Records To View</td></tr>');
				$(".currentCompGLAccount").html('<tr><td colspan="4" style="text-align:center">No Records To View</td></tr>');
				$("#companyDetails").dialog( "option", "title", "Add Company");
			       
			    $("#tabs").tabs( "option", "active", 0);
			});
		
			function viewCompany(compId){
				isEdit = false;
				isAdd = false;
				$("#companyName,#companyId,#currencyId,#costCenter,#glAccount, #dialogTableCompanyName").removeClass('pui-error');
		  		$("#companyName,#companyId,#currencyId,#costCenter,#glAccount,#dialogTableCompanyName").attr('data-original-title','');
			   	$("#companyDetailErr").hide();
			   	$("#save,#add").hide();
			     	//$("#companyDetails").addClass("view");
			   	$(".companyName,.companyId,.costCenter,.glAccount,.comps, #isMasterCmpny").attr("disabled",true);
			   	$(".currencySourceId").attr("disabled", true);
			   	$("#spinner").show();
			   	getCompanyDetails(compId);
				$(".delGLAcc").hide();
			   	$('#companyDetails').dialog('open');	
			   	$("#companyDetails").dialog( "option", "title", "View Company");
			       	
			    $("#tabs").tabs( "option", "active", 0);
			   	$("#spinner").hide();
			}
			
			function editCompany(compId){
				editCompanyId = compId;
				isEdit = true;
				isAdd = false;
				$("#companyName,#companyId,#currencyId,#costCenter,#glAccount").removeClass('pui-error');
				$("#companyName,#companyId,#currencyId,#costCenter,#glAccount").attr('data-original-title','');
				$("#companyDetailErr").hide();
				$(".companyName,.companyId,.costCenter,.glAccount, #isMasterCmpny").attr("disabled",false);
				$(".currencySourceId").attr("disabled", false);
				$('#companyDetails').removeClass('view');
				$("#spinner").show();
				getCompanyDetails(compId);
				$(".delGLAcc").show();
				$('#companyDetails').dialog('open');
			 	$("#companyDetails").dialog( "option", "title", "Edit Company");
			      
			 	$("#tabs").tabs( "option", "active", 0);
			 	$("#save,#add").show();
			 	$("#spinner").hide();
			}
		
			function getCompanyDetails(compId){
				
				$("#companyName,#companyId,#currencySourceId,#costCenter,#glAccount").val('');
				$.ajax({
					type: "POST",
					async:false,
					dataType:"json",
					data: {compId : compId},
					url: '<g:createLink controller="accounting" action="getCompany"/>',
					success: function(response){
						setCompanyDetails(response.companyDtls);
						setCompanyOptions(response.companies);
						setAccounts(response.glAccounts, response.otherGLAccounts);
					}
				});
			}
			
			function setCompanyOptions(data){
				options = '';
				options += '<option value="null">&lt;&lt;Please Select&gt;&gt;</option>';
	
				$.each(data, function (key, value) {
					options += '<option value="'+value.id+'">'+value.companyName+'</option>';
				});
			}
		
			function setCompanyDetails(data){
				var isMasterCmpny = data.isMasterCompany;
				$('.companyName').val(data.companyName);
				$('.companyId').val(data.companyId);
				$('.currencySourceId').val(data.currencyId.id);
				$('.costCenter').val(data.costCenter);			
				$('.glAccount').val(data.glAccount);
				$("#isMasterCmpny").prop("checked", isMasterCmpny);
			}
		
			function setAccounts(glAccounts, otherGLAccounts){
				$(".currentCompGLAccount").html('');
				$(".otherCompGLAccount").html('');
				$(".currentCompGLAccount").append(formTable(glAccounts, 'current'));
				$(".otherCompGLAccount").append(formTable(otherGLAccounts, 'other'));
				
			}
		
			function formTable(data, type){
				var content = '';
				var costCenter = '', glAcc = '', rowIdx = '';
				if(data.length == 0){
					content += '<tr><td colspan="4" style="text-align:center">No Records To View</td></tr>';
				} else{
					$.each(data, function(idx, val){
						costCenter = '', glAcc = '';
						rowIdx = (typeof val.rowIdx == 'undefined') ? val.companyGLAccount.id : val.rowIdx;
						val.costCenter = (val.costCenter == null) ? '' : val.costCenter;
						val.glAccount = (val.glAccount == null) ? '' : val.glAccount;
						if((isEdit && val.source.id == editCompanyId) || isAdd){
							costCenter += '<input name="costCenter" value ="'+val.costCenter+'" class="empty col-md-12 pui-input costCenter" onChange = "isChanged(event)" onkeypress = "costCenterKeyPress(event)"/>';
							glAcc += '<input name="glAccount" value ="'+val.glAccount+'" class="empty col-md-12 pui-input glAccount" onChange = "isChanged(event)" onkeypress = "glAccountKeyPress(event)" maxlength="8"/>';
						} else{
							costCenter += val.costCenter;
							glAcc += val.glAccount;
						}
		
						content += '<tr id="'+rowIdx+'">';
						content += '<td accountId="'+val.companyGLAccount.id+'">'+val.companyGLAccount.companyName+'</td>';
						content += '<td>'+costCenter+'</td>';
						content += '<td>'+glAcc+'</td>';
						if(type != 'other' && isEdit){
							if(val.source.id == editCompanyId)
								content += '<td id="'+val.id+'" class="delGLAcc" onclick="deleteAccount('+val.id+')"><i class="fa fa-trash" aria-hidden="true"></i></td>';
							else
								content += '<td></td>';
						}
						
						content += '</tr>';
					});
				}
				return content;
			}
			
			function deleteAccount(id){
	
				if(!parseInt(id)){
					var rowIdx = $(id.target).closest('tr').attr('id');
					$(id.target).closest('tr').remove();
					$(".otherCompGLAccount").find('tr#'+rowIdx).remove();
					return true;
				}
	
				$("#delAccDlg").dialog({
					autoOpen: false,
					width: 350,
					height: "auto",
					resizable: false,
					modal: true,
					buttons: {
						"Yes": function() {
							delAccountConfirm(id);
						},
						 "No": function() {
							$(this).dialog( "close" );
						 }
					},
			   });
	            $("#delAccDlg").dialog('open');
			}
			
			function delAccountConfirm(accId){
				$("#delAccDlg").dialog('close');
				$('#spinner').show();
				$.ajax({
					type:'POST',	   	 		
					url:'<g:createLink controller="accounting" action="deleteAccount"/>?accountId='+accId,
					success:function(data){	
						if(data.status=='Success'){
							editCompany(editCompanyId);
							$("#companyDetailErr").removeClass('alert alert-danger').addClass('alert alert-success');
					    	$("#companyDetailErr").show();
					    	$("#pageMessageText").html('');
					    	$("#companyDetailErr").html('<span id="pageMessageText" class="message"><strong><em class="icon-check"></em></strong>'+data.successMessage+'</span>');
						} else if(data.status=='Failure') {
					 		$("#companyDetailErr").removeClass('alert alert-success').addClass('alert alert-danger');
							$("#companyDetailErr").show();
							$("#pageMessageText").html('');
							$("#companyDetailErr").html('<span id="pageMessageText" class="message"><strong><i class="icon" data-icon=""></i></strong>'+data.pageErrorMessage+'</span>');
						}   	 			
					},
					error:function(XMLHttpRequest,textStatus,errorThrown){
				   	 	
				   	},
				   	complete: function() {
				   		$('#spinner').hide();
					}
				});
			}
				
			function isChanged(e){
				$(e.target.closest('tr')).addClass('isDirty');
			}
			
			function costCenterKeyPress(e){
				if(!$.isNumeric(e.key) && e.key != '-' && $.inArray(e.keyCode,[8,9,46,37,39]) == -1){
					e.preventDefault();
				}
			}
			
			function glAccountKeyPress(e){
				if(!$.isNumeric(e.key) && $.inArray(e.keyCode,[8,9,46,37,39]) == -1){
					e.preventDefault();
				}
			}
			
		</script>
	</body>
</html>