<%@ page contentType="text/html;charset=UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1" />
<meta name="layout" content="main" />
<link rel="shortcut icon" href="${resource(dir: 'images', file: 'favicon.ico')}" type="image/x-icon">
<title>Expense Types</title>
<style>
.mb {	margin-top: 5%;}
#wrap:nth-child(even) {	background-color: #90EE90;}
#wrap:nth-child(odd) {	background-color: #ccccff;}

#expenseTypeDetails{
padding-bottom:3px;
padding-top:10px;
}
</style>

</head>
<body>
	<div class="body">
		<pui:menu type="page" objectType="-1" context="accounting" appCode="PPM" title="Expense Types" model="" />
	</div>
	<div class="mb"></div>
	<div class="clear"></div>

	<div class="col-md-12" style="width: 40%;">
		<table
			class="table table-striped table-bordered table-hover pui-table-grid display dataTable no-footer"
			id="expenseTypes" style="margin: 0px; word-wrap: break-word;">
			<thead>
				<tr>
					<th width="10%"><g:message
							code="com.prolifics.ppmweb.company.company.sno" /></th>
					<th width="70%"><g:message
							code="com.prolifics.ppmweb.projectExpense.create.expType" /></th>
					<th width="20%"><g:message
							code="com.prolifics.ppmweb.company.company.action" /></th>
				</tr>
			</thead>
			<tbody>

				<g:if test="${expenseTypesSource}">
					<% int i=0; %>
					<g:each in="${expenseTypesSource}" var="expenseTypes">
						<tr class="pui-altcolor" id="wrap">
							<% i++ %>
							<td style="text-align: center;">
								${i}
							</td>
							
							<td>
								<g:if test="${expenseTypes.isActive}">
										${expenseTypes.lkupName}
								</g:if>
								<g:else>
										<i style="opacity:0.8;">${expenseTypes.lkupName}</i>
								</g:else>
							</td>
							<td class="text-center">
							<a href="javascript:viewExpenseType(${expenseTypes.id},'${expenseTypes.lkupName}');" class="viewExpenseType ui-pg-button ui-pg-div"><i style="opacity: 0.5; height: 18px; font-size: 15px; color: black;" class="fa fa-eye"></i></a> 
							<g:if test="${isReadOnly==false}">
							<a href="javascript:editExpenseType(${expenseTypes.id},'${expenseTypes.lkupName}');" class="editExpenseType ui-pg-button ui-pg-div"><i style="height: 13px;" class="ui-icon ui-icon-pencil"></i></a>
							</g:if>
							</td>
						</tr>
					</g:each>
				</g:if>
				<g:else>
					<tr>
						<td colspan=12 align="center">
							<div style="color: #555;">No Records To View</div>
						</td>
					</tr>
				</g:else>
			</tbody>
		</table>
	</div>

	<div id="expenseTypeDetails">
		<div id="expenseHeader" class="center">
			<label class="col-md-5 control-label no-padding" style="text-align:left !important;" for="expenseType"><g:message
					code="com.prolifics.ppmweb.accounting.contractTerms.contractDialogHeader" /></label>
			<span class="col-md-1 no-padding">:</span> <span id="expenseType" style="text-align:left;"
				class="col-md-5"></span>
		</div>
		 <div class="mb" ></div>
		<g:form name="editExpenseMapping">
		<div id="expenseMapping">
			<table
				class="table table-striped table-bordered table-hover pui-table-grid display  no-footer"
				id="expenseMappingTable"
				style="margin: 0px; word-wrap: break-word;">
				<thead>
					<tr>
						<th width="70%"><g:message
								code="com.prolifics.ppmweb.accounting.contractTerms.mapping" /></th>
						<th width="30%"><g:message
								code="com.prolifics.ppmweb.accounting.contractTerms.glItem" /></th>
					</tr>
				</thead>
				<tbody id="viewDialog" >				
				</tbody>
			</table>
		</div>
		 
		<div class="center">
			<button type="button" id="Save" class="btn pui-primary btn-sm" style="margin-top:5px;"
				title="Save">
				<em class="puicon-floppy19"></em>
				<g:message
					code="com.prolifics.ppmweb.projectIssue.viewPrjIssues.save" />
			</button>

		</div>
		</g:form>
	</div>



	<script type="text/javascript">

	var expenseTypeId=null;
		$(document).ready(function() {
		
					$('#expenseTypes').DataTable(
							{
								"iDisplayLength" : 19,
								"searching" : true,
								"bLengthChange": false,
								"paging" : true,
								"autoWidth" : true,
								"language" : {
									"emptyTable" : "No Records To View"
								},
								"fnRowCallback" : function(nRow, aData,
										iDisplayIndex, iDisplayIndexFull) {
									$(nRow).addClass("pui-altcolor");
								}
							});
				});
			
		$("#expenseTypeDetails").dialog({
		    autoOpen: false,
		    modal: true,
		    width: 600,
			show : 'blind',
		    height: "auto",  
		    resizable: false,
		});	

		$('#Save').click(function(){
			$('#spinner').show();
			saveAjaxCall($(this).attr("expenseTypeId")); 
		});
		
		function viewExpenseType(expenseTypeId, expenseTypeName){
					
					$("#spinner").show();
					expenseMappings(expenseTypeId);
					$(".mappedValues").attr("disabled",true);
					$("#Save").hide();
					$("#expenseType").html(expenseTypeName);
			    	$('#expenseTypeDetails').dialog('open');	
			    	$("#expenseTypeDetails")
			        .dialog({
			             title: "View Expense Types"
			        });	
			    	$("#spinner").hide();
		
					}

		function editExpenseType(expenseTypeId, expenseTypeName){
					
					$("#spinner").show();
					expenseMappings(expenseTypeId);	
					$(".mappedValues").keypress(function(e){
						if(!$.isNumeric(e.key)  && $.inArray(e.keyCode,[8,9,46,37,39]) == -1){
							e.preventDefault();
						}
					});
					$(".mappedValues").attr("disabled",false);
					$("#Save").attr("expenseTypeId",expenseTypeId).show();
					$("#expenseType").html(expenseTypeName);
			    	$('#expenseTypeDetails').dialog('open');	
			    	$("#expenseTypeDetails")
			        .dialog({
			             title: "Edit Expense Types"
			        });	
			    	$("#spinner").hide();
		
					}

		

		function expenseMappings(expenseTypeId){
			$.ajax({
				type: "POST",
				async:false,
				data:{expenseTypeId:expenseTypeId},		
				dataType:'JSON',
				url: '<g:createLink controller="accounting" action="getExpenseMapping"/>',
				success: function(response){	
					$('#viewDialog').html('');
					$.each(response.expenseMappingSource, function (key, value) {
						var html = '<tr><td style="padding:6px;">' + value['lkupName'] + '</td><td><input id="'+value["id"]+'" name="'+value["id"]+'" placeholder="xxxxx" class="empty col-md-12 pui-input mappedValues"/></td></tr>';						
						$('#viewDialog').append(html);  
					});	
					
					$.each(response.result, function (key, value) {
						$("#"+key).val(value)				
						  
					});	
					
				}
				});
			}



		function saveAjaxCall(expenseTypeId) {
			 var dataObj={};

			 $('.mappedValues').each(function(){
				dataObj[$(this).attr("name")]=	$(this).val();
			 });
		
		 	var url='<g:createLink controller="accounting" action="saveExpenseMappings"/>';
			$.ajax({
		        url:url,
		        type:'POST',
		        dataType:"json",
		        data :  {expenseTypeId: expenseTypeId, dataObj:JSON.stringify(dataObj)},		        
		        async:false,
		        
		        success:function (data) {
			       	 $('#spinner').hide();
			       	if (data.status == 'Success') {
			       		$("#spinner").show();
			       		$('#expenseTypeDetails').dialog('close');	
				       	 window.location.replace(data.nextUrl);
				    }
			         if(data.status == 'Failure'){
			         }
		        }
		  	 });
		}
		
		
				
	</script>


</body>
</html>