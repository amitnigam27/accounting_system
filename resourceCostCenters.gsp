<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1"/>
<meta name="layout" content="main"/>
<title><g:message code="com.prolifics.ppmweb.company.company.resourceCostCenter"/></title>
<link rel="shortcut icon" href="${resource(dir: 'images', file: 'favicon.ico')}" type="image/x-icon">
<style type='text/css'>
			.jstree-anchor {
				font-size: 13px;
			}
			.toggle-filter{
				height: 20px;
				background: transparent;
				box-shadow: none;
				border: 0px;
				border-left: 0px;
			}	
   			.toggleMargin{
				margin-left: 12px;
			}
			.multiSelectOptions LABEL{			
				padding: 5px 5px !important;
				font-weight:100;
				
			}
			.ui-autocomplete{
				z-index : 1039 !important;
			}
			.jstree-search,.jstree-clicked{
				color : initial !important;
				font-style: normal !important;
				background: #beebff;
				border-radius: 2px;
				box-shadow: inset 0 0 1px #999;
				font-weight: bold;
			}
			
		</style>
</head>
<body>
<pui:menu type="page" objectType="-1" context="accounting" appCode="PPM" title="Resource Cost Centers" model=""/>

<div class="clearfix" style="height:65px;"></div>
<button class="toggle-filter menu-left clear" id="outRight" title="Toggle Filters"><i class="fa fa-chevron-right"></i></button>
		<div class="col-md-2 col-xs-2 filterTab " style="max-width:25%;min-width:10%;padding-right: 0px;overflow-x: auto;">	
			<div  id="resourceTree" class="col-md-12 col-xs-12" style="padding:0px; border: 1px solid #DDDDDD;">
				<h1 class="pui-sub2-title">Reporting Hierarchy
					<button class="toggle-filter menu-left pull-right" id="inLeft" title="Toggle Filters" style="display:block !important;"><i class="fa fa-chevron-left"></i></button>
				</h1>
				<div id="hierarchy" style="overflow: auto; height: auto; "></div>
			</div>
		</div>
		
		<div class="col-md-10 col-xs-10 colonWdt" id="resTreeDt" >
			<div class="panel-group" id="searchFilter" style="margin-bottom: 10px;">
				<div class="panel panel-default">
				   <div class="panel-heading">
				   		<h4 class="panel-title" id="searchHeading">
					        <a data-toggle="collapse" href="#filters">
					        	<span class=" pull-right filterline fa fa-chevron-circle-up"></span>
					        	<g:message code="com.prolifics.ppmweb.pmo.resourceUtilization.searchFilt"/>
					        </a>
				    	</h4>
				   </div>
				 
					<div id="filters" class="panel-collapse in">
						<div class="panel-body no-padding">
				      		<div id="filtersearch" style="padding-top:1%;">	
								<div class="col-md-6 pui-require">
									<label class="col-md-4">Resource Name</label>
									<span class="col-xs-1">:</span>
									<span id = "resourceComb" class="col-md-6">
										<g:autoComplete name="resourceAutoComb" type="resource" typeId="resourceID" />
									</span>
								</div>
								<div class="clearfix" style="height:35px;"></div>
							</div>							
						</div>
						
						<div class="clearfix" style="height:10px;"></div>
								
						<div class="text-center">
							<div class="form-group">
								<div class="clearfix" style="height:5px;"></div>	
								<button type="submit" id="subBtn" class="btn btn-primary"><em class="puicon-search"></em> Search </button>						
							</div>
						</div>
					</div>	
				</div>
			</div>
			
			<div id="resDetails" style="display:none">
				<div class="col-md-12 no-padding">
					<div class="clearfix" style="height:10px;"></div>
					<div class="ui-jqgrid ui-widget ui-widget-content ui-corner-all Pr2childheight">
						<div class="ui-jqgrid-titlebar ui-jqgrid-caption ui-widget-header ui-corner-top ui-helper-clearfix">
							<span class="ui-jqgrid-title">Resource Details </span>
						</div>
						<div class="col-md-12 no-padding">
							<div class="clearfix" style="height:10px;"></div>
							<g:hiddenField name="resId" class="resId" value="" id="resId" />
							<div class="col-md-4 ">
								<div class="form-group">						
									<label class="col-md-4 col-xs-3 no-padding">Resource Name </label>
									<span class="col-md-1 col-xs-1 ">:</span>
									<span class="col-md-7 col-xs-7 no-padding" id="resName"> </span>	
								</div>									
							</div>
							<div class="col-md-4">
								<div class="form-group">						
									<label class="col-md-4 col-xs-3 no-padding">Designation </label>
									<span class="col-md-1 col-xs-1 ">:</span>
									<span class="col-md-7 col-xs-7 no-padding" id="designation"> </span>	
								</div>									
							</div>
							<div class="col-md-4">
								<div class="form-group">						
									<label class="col-md-4 col-xs-3 no-padding">Employment Type </label>
									<span class="col-md-1 col-xs-1 ">:</span>
									<span class="col-md-7 col-xs-7 no-padding" id="empType"> </span>	
								</div>									
							</div>
						</div>
						
						<div class="col-md-12 no-padding">
							<div class="clearfix" style="height:10px;"></div>
							<div class="col-md-4 ">
								<div class="form-group">						
									<label class="col-md-4 col-xs-3 no-padding">Gender</label>
									<span class="col-md-1 col-xs-1 ">:</span>
									<span class="col-md-7 col-xs-7 no-padding" id = "gender">NA</span>	
								</div>									
							</div>
							<div class="col-md-4">
								<div class="form-group">						
									<label class="col-md-4 col-xs-3 no-padding">Email ID </label>
									<span class="col-md-1 col-xs-1 ">:</span>
									<span class="col-md-7 col-xs-7 no-padding" id="emailID">-</span>	
								</div>									
							</div>		
							<div class="col-md-4">
								<div class="form-group">						
									<label class="col-md-4 col-xs-3 no-padding">Citizenship </label>
									<span class="col-md-1 col-xs-1 ">:</span>
									<span class="col-md-7 col-xs-7 no-padding" id="citizenship">NA</span>	
								</div>									
							</div>
						</div>
						<div class="col-md-12 no-padding">
							<div class="clearfix" style="height:10px;"></div>
							<div class="col-md-4 ">
								<div class="form-group">						
									<label class="col-md-4 col-xs-3 no-padding">Business Unit</label>
									<span class="col-md-1 col-xs-1 ">:</span>
									<span class="col-md-7 col-xs-7 no-padding" id = "bu"> </span>	
								</div>									
							</div>
							<div class="col-md-4">
								<div class="form-group">						
									<label class="col-md-4 col-xs-3 no-padding">Supervisior </label>
									<span class="col-md-1 col-xs-1 ">:</span>
									<span class="col-md-7 col-xs-7 no-padding" id="supervisor"> - </span>	
								</div>									
							</div>
							<div class="col-md-4">
								<div class="form-group">						
									<label class="col-md-4 col-xs-3 no-padding">Gross Capacity</label>
									<span class="col-md-1 col-xs-1 ">:</span>
									<span class="col-md-7 col-xs-7 no-padding" id="gCapacity">-</span>	
								</div>									
							</div>		
						</div>
						<div class="col-md-12 no-padding">
							<div class="clearfix" style="height:10px;"></div>
							<div class="col-md-4 ">
								<div class="form-group">						
									<label class="col-md-4 col-xs-3 no-padding">Joining Date</label>
									<span class="col-md-1 col-xs-1 ">:</span>
									<span class="col-md-7 col-xs-7 no-padding" id = "jd"> </span>	
								</div>									
							</div>
							<div class="col-md-4">
								<div class="form-group">						
									<label class="col-md-4 col-xs-3 no-padding">End Date </label>
									<span class="col-md-1 col-xs-1 ">:</span>
									<span class="col-md-7 col-xs-7 no-padding" id="endDate"> - </span>	
								</div>									
							</div>
							<div class="col-md-4">
								<div class="form-group">						
									<label class="col-md-4 col-xs-3 no-padding">Employee Status </label>
									<span class="col-md-1 col-xs-1 ">:</span>
									<span class="col-md-7 col-xs-7 no-padding" id="empStatus"> - </span>	
								</div>									
							</div>		
						</div>
						<div class="col-md-12 no-padding">
							<div class="clearfix" style="height:10px;"></div>
							<div class="col-md-4 ">
								<div class="form-group">						
									<label class="col-md-4 col-xs-3 no-padding">Cost Center</label>
									<span class="col-md-1 col-xs-1 ">:</span>
									<span class="col-xs-7 col-md-7 pui-input no-padding">
										<div id='costCen'  style="padding:5px;">
											<i class="fa fa-plus-circle"></i> 
											<a href="javascript:void(0)" id="selCostCenter" onClick="showHierarchy()"> Select Cost Center</a>
											<input type="hidden" name="costCenterId"  id="costCenterId" />
										</div>
									</span>
								</div>									
							</div>
						</div>
					</div>
				</div>
			
			</div>	
			<div class="col-md-12 center" style=" margin-top: 10px;">
							<div class="clearfix" style="height:5px;"></div>	
							<button type="button" id="Save" class="btn pui-primary btn-sm puicon-floppy19" title="Save"><g:message code="com.prolifics.ppmweb.project.create.save" /></button>
							<button type="reset" id="Cancel" isNew="false" class="btn pui-dark-button btn-sm icon puicon-x" title="Cancel"><g:message code="com.prolifics.ppmweb.project.create.cancel" /></button>
							<div class="clearfix" style="height:5px;"></div>
			</div>
		</div>
		<div id="hierarchyPopup" >
			<div id="hierarchyPopupMsg" style="display:none;border:1px solid #B94A48;border-radius:2px" class="alert alert-danger collapse">
				<strong><em class="icon" data-icon="⚠"></em></strong>
				<span id="hierarchyPopupMsgText" class="message">Please Select a Cost Center</span>
			</div>
			<div id="costCenterSearch" class="col-md-12" >
				<label class="col-md-4 col-sm-4 col-xs-4">Search</label>
				<label class="col-xs-1">:</label>
				<div class="col-md-7">
					<g:autoComplete name="costCenterAutoComb" type="costCenter" typeId="costCenterID" placeholder="Type/Press space to get the list"/>
				</div>
			</div>
			<div class="clearfix" style="height:40px"></div>
			<div id="costCenterHierarchy" class="col-md-12" style="overflow-x:auto;"></div>
		</div>
		<script type="text/javascript">
			var resource = $.parseJSON("${res}");
		
			var isPMAndAbove = "${isPmAndAbove}";
			var prevResId;
			var resourceId =0;
			var isFullHierarchy = true;	
			var preCostCenterId=null;
			var preCostCenterName="";
		//	var costCenterName = $("#selCostCenter").attr('value');
		//	var costCenterId = $("#costCenterId").attr('value');
			
			$(document).ready(function() {
				$('#Save , #Cancel').hide();
				if (window.location.href.indexOf('resDetails')!=-1) {
					
					var redirectedResId=sessionStorage.getItem("resId");	
					console.log("redirectedResId"+redirectedResId);
					//sessionStorage.removeItem("resId");	

					var redirectedResName = window.location.href.substr(window.location.href.lastIndexOf("=") + 1).replace(/%20/g,' ');					
					console.log("redirectedResName"+redirectedResName);
					$('.resource').val(redirectedResId);
					$('#resourceAutoComb').val(redirectedResName);	

					setTimeout(
							  function() 
							  {
							    //do something special
							  }, 5000);
					resourceId = redirectedResId;
					getResDetails(redirectedResId);	
					}
				
				else{
					sessionStorage.removeItem("resId")
					getLoggedInUserDetails();
					}


				
				$("#pageMessage").hide();
			
				$.datepicker.setDefaults({changeMonth: true, changeYear: true, dateFormat: '${grailsApplication.config.JS_DATE_FORMAT}', yearRange: '-100:+10'});
				$('#resourceAutoComb').autocomplete({

					source: '<g:createLink controller="search" action="resourceSearchWithActiveInactive" />',
					autoFocus: true,
					select: function( event, ui ) {
						$('.resource').val(ui.item.id);
						$('#resourceAutoComb').val(ui.item.value);								
					}				
				});

				$("#resourceAutoComb").keydown(function(event){ 
				    if(event.keyCode == 13) {
				    	$("#subBtn").trigger('click')
				    }
				 });

				$('.toggle-filter').click(function(){
					$('#outRight').toggle();
					$('.filterTab').toggleClass('clear');
					 $('#resTreeDt').toggleClass('col-md-10 col-xs-10',200).toggleClass('col-md-12 col-xs-12',200);
	                $('.toggle-filter').toggleClass('toggleMargin');
	            });
	            
				$("#resId").val($('#resourceID').val());
				
				$('#resourceAutoComb').on("keypress",function(){
					prevResId = $('#resourceID').val();
					$('#resourceID').val('null');	
				});

				$('#subBtn').click(function() {
					$('.spinner').show();
					
					var resId = $('#resourceID').val();
					$("#resId").val(resId);
					if(resId!= 'null'){
						resourceId = resId
						$("#pageMessage").hide();
						getResDetails(resId);
					}
					else{
						$('.spinner').hide();
						$("#resId").val(prevResId);
						$("#pageMessage").attr('class', 'alert alert-danger');
						$("#resourceComb").addClass('pui-error');
						$("#pageMessage").html('<span id="pageMessageText" class="message"><strong><i class="icon" data-icon=""></i></strong>Please Enter Resource Name</span>');
						$("#pageMessage").show();
					}
					
	    		});

	    		$('#costCenterHierarchy').on("select_node.jstree", function (e, data) {
					$("a[class*='jstree-clicked']").each(function( index ) {				
						if($(this).text() != data.node.text){
							$(this).removeClass();
							$(this).addClass('jstree-anchor');
						}
					});
				});
				
				$('#costCenterAutoComb').autocomplete({
					source: '<g:createLink controller="search" action="getCostCenters" params="['searchFor': 'resource']"/>',
					select: function(event, ui) {
						$('.costCenter').val(ui.item.id);
						$('#costCenterAutoComb').val(ui.item.value);
						$('#costCenterHierarchy').jstree(true).settings.search.ajax.data = {"op":"path","parentId":ui.item.id};
						$('#costCenterHierarchy').jstree('deselect_all');
						isJsTreeSearch = true;
						$('#costCenterHierarchy').jstree("search",ui.item.value);
					}				
				});
				
				$("#hierarchyPopup").dialog({
				    autoOpen: false,
				    modal: true,
				    width: 600,
				    height: 'auto', 
				    resizable: false,  
				    title:'Cost Centre Directory',
				    buttons: [
				    	 {
				    		 text: "OK",
				             "class": 'btn pui-primary btn-sm ',
				             click: function() {
				            	var costCenterId='';
					     		var costCenterName='';
					     		selNode = $("a[class*='jstree-clicked'],a[class*='jstree-search']");
		 						costCenterId = selNode.closest('li').attr('id');
		  					    costCenterName = selNode.text();
		  					    if(costCenterId != undefined){
		  					    	$("#hierarchyPopupMsg").hide();
						     		$('#selCostCenter').text(costCenterName);
						     		$('#costCenterId').val(costCenterId);
						     		$(this).dialog("close");
					     		}else{
					     			$("#hierarchyPopupMsg").show();
					     		}
					     		if(costCenterId != preCostCenterId )
									$('#Save , #Cancel').show();
					     		else 
					     			$('#Save , #Cancel').hide();
				             }
					     }
			   	 	],
		   	 		
				});
			    	
			});

			$('#Cancel').on('click', function(){
				$('#selCostCenter').text(preCostCenterName);
	     		$('#costCenterId').val(preCostCenterId);
	     		$('#Cancel , #Save').hide();
			});

			$('#Save').on('click', function(){
			  var costCenterID=	$('#costCenterId').attr('value');
			  var searchID =$('#resourceID').attr('value');
				$('.spinner').show();	
				
				$.ajax('<g:createLink controller="accounting" action="saveResourceCostCenters" />', {
		    		dataType:"json",
		    		data: {'resId' : searchID , 'costCenterId':costCenterID },
		    		type:"POST",
		    		async: "false",
				    success: function(response) {
				    	$('#spinner').hide();
				    	$('#pageMessage').addClass('alert-success');
				    	$('#Cancel , #Save').hide();
				    	$('#pageMessage').html('<span id="pageMessageText" class="message "><strong><em class="icon-check"></em></strong>'+response.pageMessageInfo+'</span>').show();
				
				    	getResDetails(searchID);
				    	$("#costCenterHierarchy").jstree("close_all");
					   }
				});
			});
			
			function loadTree() {
				
				$('#hierarchy').jstree('destroy')
				$('#hierarchy').jstree({
					"core" : {
						'data' : {
							'url' : "${request.contextPath}/resource/getResourcesUpwardHierarchy?resId="+resourceId,
							'data' : function (node) {
								return {'op' : 'children', 'parentId' : node.id}; 
							}
						}
					}
				})
				.on('hover_node.jstree',function(e, data){
					$("#"+data.node.id).prop('title', data.node.text);
				});				

				$('#hierarchy').on('ready.jstree', function() {
				    $("#hierarchy").jstree("open_all");          
				});

				$('#hierarchy').height(function(index, height) {
					return window.innerHeight - $(this).offset().top;
				});
			}

			function getLoggedInUserDetails(){
				$('.resource').val(resource.id);
				$('#resourceAutoComb').val(resource.label);	
				if(!isPMAndAbove){
					$('#resourceAutoComb').attr('disabled', 'disabled');
					$('#subBtn').hide();
				}
				else {
					$('#resourceAutoComb').removeAttr('disabled');
					$('#subBtn').show();
				}
				$('.spinner').show();	
				getResDetails(resource.id);
			}

			function getResDetails(resId) {
				loadTree();
				$.ajax('<g:createLink controller="resource" action="getResProfile" />', {
		    		dataType:"json",
		    		data: {resId : resId},
		    		type:"POST",
		    		async: "false",
				    success: function(response) {	
					   
				    	$("#current").prop('checked', true); 
				    	$("#currentTrainings").prop('checked', true); 
				    	$("#resourceComb").removeClass('pui-error');
				    	$("#resName").text(response.resDtls[0].resName);
				    	$("#emailID").text(response.resDtls[0].emailID);
				    	$("#gender").text(response.resDtls[0].gender);
				    	$("#jd").text(response.resDtls[0].joiningDate);
				    	$("#endDate").text(response.resDtls[0].res_endDate);
				    	$("#empStatus").text(response.resDtls[0].user_status);
				    	$("#designation").text(response.resDtls[0].designation);
				    	$("#gCapacity").text(response.resDtls[0].gCapacity);
				    	$("#empType").text(response.resDtls[0].empType);
				    	$("#bu").text(response.resDtls[0].businessUnit);
				    	$("#citizenship").text(response.resDtls[0].citizenship);
				    	if(response.resDtls[0].supervisor != null){
				    		$("#supervisor").text(response.resDtls[0].supervisor);
				    	}
				    	if((response.resDtls[0].cost_center_name != null) && (response.resDtls[0].cost_center_id != null)){
				    		$("#selCostCenter").text(response.resDtls[0].cost_center_name);
				    		$("#costCenterId").val(response.resDtls[0].cost_center_id);
				    		preCostCenterId=response.resDtls[0].cost_center_id;
				    		preCostCenterName=response.resDtls[0].cost_center_name;
					    }
				    	else{
				    		preCostCenterId=null;
				    		preCostCenterName="Select Cost Center";
				    		$("#selCostCenter").text('Select Cost Center');
				    		$("#costCenterId").val(null);
					    }
				    	
				    	
				    	 		
		    		},
		    		error: function (xhr, status, error) {
		    			console.log(xhr);
		    	    },
		    	    complete: function () {
		    	        // Handle the complete event
		    	        $('#resDetails').show();
		    	    	$("#spinner").hide();
		    	    }
				}); 
			}

			function showHierarchy() { 
				
				if($('#costCenterHierarchy').html().length == 0) {
					isJsTreeSearch = true;
					$('#costCenterHierarchy').jstree({
						"plugins" : [ "themes","json_data","search", "ui"],
						"core" : {
							'data' : {
								'url' : "${request.contextPath}/accounting/getCostCenters?isFullHierarchy="+isFullHierarchy,
								'data' : function (node) {
									isJsTreeSearch = true;
									return {'op': 'children', 'parentId': node.id, 'showDisabled': true, 'enableFor': 'resource'}; 
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
						$('#costCenterHierarchy').jstree('clear_search'); 
						$('#selCostCenter').val(data.node.id);
					}).bind('search.jstree',function(e, data){
						isJsTreeSearch = false;
						var $container = $('#costCenterHierarchy'), $scrollTo = $('a.jstree-search'); 
						$container.animate({
						    scrollTop: $scrollTo.offset().top - $container.offset().top + $container.scrollTop()
						}); 
						$('#selCostCenter').val(data.res[0]);
					}); 
			}
			$('#costCenterAutoComb').val(''); 
			$('#hierarchyPopup').dialog('open');
			return true;
		}
		</script>	
	</body>
</html>