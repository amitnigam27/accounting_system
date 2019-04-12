<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1"/>
<meta name="layout" content="main"/>
<link rel="shortcut icon"
	href="${resource(dir: 'images', file: 'favicon.ico')}"
	type="image/x-icon">
<title>Cost Centers</title>
<style> 
.jstree-anchor {
	font-size: 13px;
}
#hierarchy{
	max-height: 300px !important;
	
}
.eventsNone {
	pointer-events:none;
	opcacity:1.0 !important;
}

.jstree-search,.jstree-clicked{
	color : initial !important;
	font-style: normal !important;
	background: #beebff;
	border-radius: 2px;
	box-shadow: inset 0 0 1px #999;
	font-weight: bold;
}
.mandatory{
	color:red;
}
#hierarchy{
	padding-left:17%;
}
.mt5{
margin-top:5px;
}
</style>
</head>
<body>

<pui:menu type="page" objectType="-1" context="accounting" appCode="PPM" title="Cost Centers" model=""/>
<div class="mb" style="height:50px;"></div>
	<div class="clear"></div>
	<div class="col-md-12">
	<div class="col-md-4 col-sm-4 col-xs-4" >
			<button   type="button" id="addCostCenter"  
				class="btn pui-primary btnCostcenter eventsNone " 
				title="${message(code:'com.prolifics.ppmweb.company.company.addCostCenter')}">
				 
				<g:message
					code="com.prolifics.ppmweb.company.company.addCostCenter" />
			</button>
	

			<button  type="button" id="editCostCenter" 
				class="btn pui-primary btnCostcenter eventsNone" style="margin-left:3%;"
				title="${message(code:'com.prolifics.ppmweb.company.company.editCostCenter')}"> 
				<g:message
					code="com.prolifics.ppmweb.company.company.editCostCenter" />
			</button>
	</div>
	 
	</div>
	
	   <div class="clearfix" style="height:40px"></div>
	
  <div class="col-md-6" >
	 
	 <div id="hierarchyPopupMsg" style="display:none;border:1px solid #B94A48;border-radius:2px" class="alert alert-danger collapse">
		<strong><em class="icon" data-icon="⚠"></em></strong>
		<span id="hierarchyPopupMsgText" class="message">Please Select a Cost Center</span>
	</div>
	<div id="resSearch" class="col-md-12 no-padding" >
		<label class="col-md-2 col-sm-2 col-xs-4 mt5">Search</label>
		<label class="col-xs-1 mt5">:</label>
		<div class="col-md-5">
			<g:autoComplete name="costCenterAutoComb" type="resource" typeId="costCenterID" placeholder="Type/Press space to get the list"/>
			<input type="hidden" id = "selCostCenter" value = "" />
		</div>
	</div>
	
	<div class="clearfix" style="height:40px"></div>
	<div id="hierarchy" class="col-md-12" style="overflow-x:auto;"></div>
	 
  </div>
  		
  <div id="costCenterDetails"
		title="${message(code:'com.prolifics.ppmweb.company.company.companyDetails')}">
		<div id="companyDetailErr"></div>
		<g:form class="form-vertical" name="ccDetails">
		<input type="hidden" id="costCenterId" value="" />
		<input type="hidden" id="saveType" value="New" />
		 <div class="form-group" id="OtherCompanyAccountingGroup">
		 	<div>
		 	<table class="  dataTable no-footer"
						  style="margin: 0px;  word-wrap: break-word;">
				<tr>
					<td><b>Cost Center Name</b><span class="mandatory">*</span></td> 
					<td><div class="col-md-4 no-padding"><g:textField id="ccName" name="ccName" class="form-control col-xs-10 pui-input pui-input-required  " style="width:150px" placeholder="Cost Center Name"/></div><div class="col-md-6"><input type="checkbox" name="is_enable_resource" id="is_enable_resource" />Enable for Resources</div></td>
			   </tr>
				<tr>
					
					<td><b>Cost Center Number</b> <span class="mandatory">*</span></td> 
					<td><div class="col-md-4 no-padding"><g:textField id="ccNumber" name="ccNumber" class="form-control col-xs-10 pui-input pui-input-required  " style="width:150px" placeholder="Cost Center Number"/></div><div class="col-md-6"><input type="checkbox" name="is_enable_engagement" id="is_enable_engagement" />Enable for Engagements</div></td>
				</tr>
				<tr> 
					<td><b>Company</b> <span class="mandatory">*</span></td> 
					<td><div class="col-md-4 no-padding"><g:select name="ccCompany" from="${comps}" style="width:150px"
						optionKey="id" id="ccCompany" optionValue="companyName" class="comps"
						noSelection="${[null: "${message(code:"com.prolifics.ppmweb.common.plsSelect")}"]}"
						class="col-xs-12 pui-input pui-require" notEqual="null" /></div></td>
				</tr>
		 		
		 	</table>
		 	</div>
		 	<div class="tblAccs">
			 	<div class="col-md-6" style="margin-top: 5px; padding-left:0px;">
				<table id="tblglAcc" class="table table-striped table-bordered table-hover pui-table-grid display dataTable no-footer"
							  style="margin: 0px;  word-wrap: break-word;">
					<thead>
						<tr>
							<td style="width: 40%;">&nbsp;</td>
							<td><b>Cost Center</b></td>
							<td><b>G/L Account</b></td> 
						</tr>	
					</thead>
					<tbody class="glAccount">
						 							
					</tbody>
				</table> 
				</div>
				<div class="col-md-6"  style="margin-top: 5px;padding-right:0px;">
				<table id="tblarAcc"  class="table table-striped table-bordered table-hover pui-table-grid display dataTable no-footer"
							  style="margin: 0px;  word-wrap: break-word;">
					<thead>
						<tr>
							<td style="width: 35%;">&nbsp;</td>
							<td><b>Cost Center</b></td>
							<td><b>A/R Item / Account</b></td> 
						</tr>	
					</thead>
					<tbody class="arAccount">
						 							
					</tbody>
				</table> 
				</div>
			</div>
			
		</div>
		<div class=" col-md-12 center" style="padding-top:11px;"> 
		<div class=" col-md-12 center">
			<button type="button" id="Save" class="btn pui-primary btn-sm"
				title="Save">
				<em class="puicon-floppy19"></em>
				<g:message
					code="com.prolifics.ppmweb.projectIssue.viewPrjIssues.save" />
			</button> 
			<!--  <button type="button" id="Cancel" class="btn pui-dark-button btn-sm icon puicon-x"
				title="Cancel"> 
				<g:message
					code="com.prolifics.ppmweb.common.button.cancel" />
			</button> --> 
		</div>
		 
	 </div>	 
	 </g:form>
  </div>
  	 
  	 <div class="clear">
		  
		 
		 
	</div>
	
	<script type="text/javascript">
	var isSearch= false, isJsTreeSearch = false, isFullHierarchy = true;
	$(document).ready(function(){
		showHierarchy();
		$('.btnCostcenter').click(function() { 
			var selCCType = $(this).attr('id'); 
			if(selCCType == 'editCostCenter' )
			  $('#saveType').val('Edit');
			else
				$('#saveType').val('New');
			if($('#selCostCenter').val() == 'undefined' || $('#selCostCenter').val() == '') {
				$('#pageMessage').show();
				$('#pageMessageText').html('Please Select Cost Center');
			} else {  
				getCostCenterDetails(selCCType);
				$('#costCenterDetails').dialog('open');
				$("#costCenterDetails").dialog({
		             title: "Add/Edit Cost Center Details"
		        }); 
			}
			setTimeout(function(){
				$("#pageMessage").hide();
				$('#pageMessageText').html('');
			},3000);
		});
		$('#pageMessage').hide();
		$('#pageMessageText').html('test');
		$('#costCenterAutoComb').autocomplete({
			source: '<g:createLink controller="accounting" action="getFilterCostCenters" />',
			select: function(event, ui) {
				$('.resource').val(ui.item.id);
				$('#costCenterAutoComb').val(ui.item.value);
				$('#hierarchy').jstree(true).settings.search.ajax.data = {"op":"path","parentId":ui.item.id};
				$('#hierarchy').jstree('deselect_all');
				isJsTreeSearch = true;
				$('#hierarchy').jstree("search",ui.item.value);
			}				
		});
 
		$("#costCenterDetails").dialog({ 
		    autoOpen: false,
		    modal: true,
		    width: 850,
			show : 'blind',
		    height: "auto",  
		    resizable: false,
		});
		 
		$('#Save').click(function(){
			 var errChk = checkValidations(); 
			 if(errChk) {
				 return false;
			 }
			 var oData = {};
			 var ccDtls = {}, accounts = [];
			 
			
			var ccName = $("#ccName").val();
			var ccNumber = $("#ccNumber").val();
			var ccCompany = $("#ccCompany").val();
			
			ccDtls['costCenterId'] = $("#costCenterId").val();
			ccDtls['ccName'] = ccName;
			ccDtls['ccNumber'] = ccNumber;
			ccDtls['ccCompany'] = ccCompany;
			ccDtls['isEnableRes'] = $('#is_enable_resource').is(':checked') ? 1 : 0;
			ccDtls['isEnableEngg'] = $('#is_enable_engagement').is(':checked') ? 1 : 0;
			ccDtls['saveType'] = $("#saveType").val();  

			$.each($("#tblglAcc tr.isDirty"), function(key,val){
				var v = {}; 
				var lkupVal = $(val).find('td input.lkupC').val(); 
				v['lkupId'] = lkupVal;
				v['costCenter'] = $(val).find('td input#'+lkupVal+'_cc').val();
				v['glAcc'] = $(val).find('td input#'+lkupVal+'_gl').val();;
				accounts.push(v); 
			});

			$.each($("#tblarAcc tr.isDirty"), function(key,val){
				var v = {};
				var lkupVal = $(val).find('td input.lkupC').val(); 
				v['lkupId'] = lkupVal;
				v['costCenter'] = $(val).find('td input#'+lkupVal+'_cc').val();
				v['glAcc'] = $(val).find('td input#'+lkupVal+'_ar').val();;
				accounts.push(v); 
			});

			oData['companyDtls'] = ccDtls;
			oData['accounts'] = accounts;
			 
			saveAjaxCall(oData); 
		});
		
	});

	function saveAjaxCall(saveObj) {
		 
		$('#spinner').show();

		var url='<g:createLink controller="accounting" action="saveConCenterDtls"/>';

		$.ajax({
			url:url,
			type:'POST',
			data : {saveObj:JSON.stringify(saveObj)},
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
	
	 
	function getCostCenterDetails(selType) {
		$('#arAccount,#glAccount').html('');
		$('#costCenterDetails tbody.glAccount,#costCenterDetails tbody.arAccount').html('');
		$('#is_enable_resource,#is_enable_engagement').prop( "checked",false );
		$('#ccName,#ccNumber').val(''); 
		$('#ccCompany').val('null');
		$('#ccName').parent().removeClass('pui-error');
		$('#ccNumber').parent().removeClass('pui-error');
		$('#ccCompany').parent().removeClass('pui-error');
		$.ajax({
			type: "POST",
			async:false,
			data:{costCenterId: $('#selCostCenter').val()},
			dataType:"json",
			url: '<g:createLink controller="accounting" action="getCostCenterDetails"/>',
			success: function(response){
				 
				if(response.status == 'Success'){  
					$('#costCenterId').val(response.costCenter.id); 
					if(selType == 'editCostCenter')  {
						$('#ccName').val(response.costCenter.costCenterName);
						$('#ccNumber').val(response.costCenter.costCenterNumber);
						$('#ccCompany').val(response.costCenter.company.id);
						if(response.costCenter.isEnableForResource)
							$('#is_enable_resource').prop( "checked",true );
						if(response.costCenter.isEnableForEngagements)
							$('#is_enable_engagement').prop( "checked",true );
					}  
					$.each(response.ccGLMappingSource, function (key, value) { 
						var html = '<tr><td style="padding:6px;">' + value.lkupName + '</td><td class="center"><input type="hidden" name="trval" class="lkupC" value = "'+value.id+'" /><input id="'+value.id+'_cc" name="'+value.id+'_cc" value="" onChange="addIsDirty(event)" placeholder="xxxxx" class="col-md-10 pui-input mappedValues "/></td><td class="center"><input id="'+value.id+'_gl" name="'+value.id+'_gl" onChange="addIsDirty(event)" value="" placeholder="xxxxx" class="col-md-10 pui-input mappedValues "/></td></tr>';					
						$('#costCenterDetails tbody.glAccount').append(html);  
					});
					$.each(response.ccARMappingSource, function (key, value) {
						var html = '<tr><td style="padding:6px;">' + value.lkupName + '</td><td class="center"><input type="hidden" name="trval" class="lkupC" value = "'+value.id+'" /><input id="'+value.id+'_cc" name="'+value.id+'_cc" value="" onChange="addIsDirty(event)" placeholder="xxxxx" class="col-md-10 pui-input mappedValues "/></td><td class="center"><input id="'+value.id+'_ar" name="'+value.id+'_ar" onChange="addIsDirty(event)" value="" placeholder="xxxxx" class="col-md-10 pui-input mappedValues"/></td></tr>';						
						$('#costCenterDetails tbody.arAccount').append(html);  
					}); 
					 
					if(selType == 'editCostCenter')  {
						$.each(response.costCenterDtls.glAcc, function (key, value) {
							  $("#"+value.lkupId+"_cc").val(value.costCenterValue);
							  $("#"+value.lkupId+"_gl").val(value.accountValue);				
							  
						});	
						$.each(response.costCenterDtls.arAcc, function (key, value) {
							 $("#"+value.lkupId+"_cc").val(value.costCenterValue);
							  $("#"+value.lkupId+"_ar").val(value.accountValue);
						});	
					}
				}		
				
				if(response.status == 'Failure'){
					$('#pageMessage').removeClass('alert-success').addClass('alert-danger collapse');
					$('#pageMessage').html('<span id="pageMessageText" class="message"><strong><i class="icon" data-icon=""></i></strong>'+response.fieldErrorMessages.searchName+'</span>').show();
				}
			},
	        complete : function(e) {
	        	$('#spinner').hide();	
		    } 						
		});
		
	}

	function checkValidations() {
		var ccName = $("#ccName").val();
		var ccNumber = $("#ccNumber").val();
		var ccCompany = $("#ccCompany").val();
		var error = 0;

		if(ccName == '') {
			$('#ccName').parent().addClass('pui-error');
			error++;
		} else {
			$('#ccName').parent().removeClass('pui-error');
		}
		if(ccNumber == '') {
			$('#ccNumber').parent().addClass('pui-error');
			error++;
		} else {
			$('#ccNumber').parent().removeClass('pui-error');
		}
		 
		if(ccCompany == 'null') {
			$('#ccCompany').parent().addClass('pui-error');
			error++;
		} else {
			$('#ccCompany').parent().removeClass('pui-error');
		}
		if(error > 0) {
			$('#pageMessage').hide();
			
			$("#companyDetailErr").attr('class', 'alert alert-danger collapse');	
			$("#companyDetailErr").show();
			$("#companyDetailErr").html('<span id="pageMessageText" class="message"><strong><i class="icon" data-icon=""></i></strong>Please Select Mandatory Fields</span>');
			setTimeout(function(){
				$("#companyDetailErr").hide();
				$('#companyDetailErr').html('');
			},5000);
			return true;
		} else {
			return false;
		}
	}
	
	function showHierarchy() { 
		if($('#hierarchy').html().length == 0) {
			isJsTreeSearch = true;
			$('#hierarchy').jstree({
				"plugins" : [ "themes","json_data","search", "ui"],
				"core" : {
					'data' : {
						'url' : "${request.contextPath}/accounting/getCostCenters?isFullHierarchy="+isFullHierarchy,
						'data' : function (node) {
							isJsTreeSearch = true;
							return {'op': 'children', 'parentId': node.id}; 
						}
					}
				},
				"search" : {
					"ajax" : {
						"url" : "${request.contextPath}/accounting/getCostCenterUpwardHierarchy",
						"async" : false
					}
				}
				
			}).on('loaded.jstree', function (e, data){
				isJsTreeSearch = false; 
				$("#costCenterAutoComb").focus();	
			}).bind("select_node.jstree", function (e, data) {
				$('#hierarchy').jstree('clear_search'); 
				$('#selCostCenter').val(data.node.id);
				openBtnAction(data.node.id);
			}).bind('search.jstree',function(e, data){
				isJsTreeSearch = false;
				var $container = $('#hierarchy'), $scrollTo = $('a.jstree-search'); 
				$container.animate({
				    scrollTop: $scrollTo.offset().top - $container.offset().top + $container.scrollTop()
				}); 
				$('#selCostCenter').val(data.res[0]);
				openBtnAction(data.res[0]);
			}); 
		}
		$('#costCenterAutoComb').val(''); 
		return true;
	}
	function addIsDirty(e) { 
		$(e.target.closest('tr')).addClass('isDirty');
	} 

	function openBtnAction(ccId) {
		if(ccId > 1) {
			$('#editCostCenter').removeClass('eventsNone');
		} else {
			$('#editCostCenter').addClass('eventsNone');
		}
		if(ccId > 0) {
			$('#addCostCenter').removeClass('eventsNone');
		} else {
			$('#addCostCenter').addClass('eventsNone');
		}
	}
	</script>
</body>
</html>