<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1"/>
<meta name="layout" content="main"/>
<link rel="shortcut icon" href="${resource(dir: 'images', file: 'favicon.ico')}" type="image/x-icon">
<title>Contract Terms</title>
<style>
.mb{margin-top:5%;}
#wrap:nth-child(even) {background-color: #90EE90;}
#wrap:nth-child(odd) {background-color:#ccccff;}

#contractTermDetails{
	padding-bottom:3px;
    padding-top: 10px;
}
</style>

</head>
<body>
  <div class="body">
  <pui:menu type="page" objectType="-1" context="accounting" appCode="PPM" title="Contract Terms" model=""/>
  </div>
   <div class="mb" ></div>
  <div class="clear"></div>
  
  <div class="col-md-12" style="width:40%;">
	  <table
		class="table table-striped table-bordered table-hover pui-table-grid display dataTable no-footer"
		id="contractTerms"
		style="margin: 0px;  word-wrap: break-word;">
  		<thead>
			<tr>
				<th width="10%"><g:message code="com.prolifics.ppmweb.company.company.sno" /></th>
				<th width="70%"><g:message code="com.prolifics.ppmweb.search.search.contractTerms" /></th>
				<th width="20%"><g:message code="com.prolifics.ppmweb.company.company.action" /></th>
			</tr>
		</thead>
				<tbody>
				
				<g:if test="${contractTermsSource}">
				<% int i=0; %>
				<g:each in="${contractTermsSource}" var="contractTerms" >
				<tr class="pui-altcolor" id="wrap">
					<% i++ %>
					<td style="text-align: center;">${i}</td>
					<td>${contractTerms.lkupName}</td>
					<td class="text-center">
					<a href= "javascript:viewContractTerm(${contractTerms.id},'${contractTerms.lkupName}');" class="viewContractTerm ui-pg-button ui-pg-div"><i style="opacity:0.5;height:18px;font-size:15px; color:black;" class="fa fa-eye"></i></a>
					<g:if test="${isReadOnly==false}">
					<a href= "javascript:editContractTerm(${contractTerms.id},'${contractTerms.lkupName}');" class="editContractTerm ui-pg-button ui-pg-div"><i style="height:13px;" class="ui-icon ui-icon-pencil"></i></a>
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
  
  
	<div id="contractTermDetails">
		<div id="contractHeader" class="center">
			<label class="col-md-5 control-label no-padding" style="text-align:left;" for="contractTerm"><g:message
					code="com.prolifics.ppmweb.accounting.contractTerms.contractDialogHeader" /></label>
			<span class="col-md-1 no-padding">:</span> <span id="contractTermType" style="text-align:left;"
				class="col-md-5"></span>
		</div>
		 <div class="mb" ></div>
		 <div class="col-md-12 no-padding" style="margin-bottom:5px;"><div class="col-md-4 no-padding"><input type="checkbox" name="is_billable" disabled="disabled" id="is_billable" />Is Billable</div></div>
		<g:form name="editContractMapping">
		<div id="contractMapping">
			<table
				class="table table-striped table-bordered table-hover pui-table-grid display  no-footer"
				id="contractMappingTable"
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




	<script  type="text/javascript">
	
	var contractTermId=null;
  	$(document).ready(function(){
  		
  		$('#contractTerms').DataTable( {
  			"iDisplayLength": 13,
			"searching": true,
			"bLengthChange": false,
			"paging":   true,
			"autoWidth": true,
			"language": {
				"emptyTable":     "No Records To View"
			},
			"fnRowCallback": function(nRow, aData, iDisplayIndex, iDisplayIndexFull) {
				$(nRow).addClass("pui-altcolor");
			}
		});
  	  	});

  	
		$("#contractTermDetails").dialog({
		    autoOpen: false,
		    modal: true,
		    width: 600,
			show : 'blind',
		    height: "auto",  
		    resizable: false,
		});

		function viewContractTerm(contractTermId, contractTermName){
			
			$("#spinner").show();
			contractMappings(contractTermId);
			$(".mappedValues").attr("disabled",true);
			$("#Save").hide();
			$("#contractTermType").html(contractTermName);
	    	$('#contractTermDetails').dialog('open');	
	    	$("#contractTermDetails")
	        .dialog({
	             title: "View Contract Terms"
	        });	
	    	$("#spinner").hide();

			}
		
		function editContractTerm(contractTermId, contractTermName){
			
			
			$("#spinner").show();
			contractMappings(contractTermId);	
			$(".mappedValues").keypress(function(e){
				if(!$.isNumeric(e.key)  && $.inArray(e.keyCode,[8,9,46,37,39]) == -1){
					e.preventDefault();
				}
			});
			$(".mappedValues").attr("disabled",false);
			$("#Save").attr("contractTermId",contractTermId).show();
			$("#contractTermType").html(contractTermName);
	    	$('#contractTermDetails').dialog('open');	
	    	$("#contractTermDetails")
	        .dialog({
	             title: "Edit Contract Terms"
	        });	
	    	$("#spinner").hide();

			}

		$('#Save').click(function(){
			$('#spinner').show();
			saveAjaxCall($(this).attr("contractTermId")); 
		});
		
		function contractMappings(contractTermId){
			$(".mappedValues").val('');
			$.ajax({
				type: "POST",
				async:false,
				data:{contractTermId:contractTermId},		
				dataType:'JSON',
				url: '<g:createLink controller="accounting" action="getContractMapping"/>',
				success: function(response){	
					$('#viewDialog').html('');
					if(response.contTerms.val == 1)
						$('#is_billable').prop('checked',true)
					else  
						$('#is_billable').prop('checked',false)
					$.each(response.contractMappingSource, function (key, value) {
						var html = '<tr><td style="padding:6px;">' + value['lkupName'] + '</td><td><input id="'+value["id"]+'" name="'+value["id"]+'" value="" placeholder="xxxxx" class="col-md-12 pui-input mappedValues"/></td></tr>';						
						$('#viewDialog').append(html);  
					});	
						
					$.each(response.result, function (key, value) {
						$("#"+key).val(value);				
						  
					});	
					
				}
				});
			}
		 function saveAjaxCall(contractTermId) {
				 var dataObj={};

				 $('.mappedValues').each(function(){
					dataObj[$(this).attr("name")]=	$(this).val();
				 });
			
			 	var url='<g:createLink controller="accounting" action="saveContractMappings"/>';
				$.ajax({
			        url:url,
			        type:'POST',
			        dataType:"json",
			        data :  {contractTermId: contractTermId, dataObj:JSON.stringify(dataObj)},		        
			        async:false,
			        
			        success:function (data) {
				       	 $('#spinner').hide();
				       	
				       	if (data.status == 'Success') {
				       		$('#contractTermDetails').dialog('close');	 
					       	window.location.replace(data.nextUrl)
					       }
				         if(data.status == 'Failure'){
				        }
			        }
		  	 });
		 }
		 
		


  </script>
  
  
</body>
</html>