package com.prolifics.ppmweb

import grails.converters.JSON

import com.prolifics.ppmweb.commons.core.LkupType
import com.prolifics.ppmweb.commons.core.LkupTypeGroup
import com.prolifics.ppmweb.commons.core.User
import com.prolifics.ppmweb.constant.Constants

class AccountingController {

    def messageService
	def accountingService
	def allocationService
	def lkupTypeService
	def securityService
	def messageSource
	def utilService
	def pars

	def beforeInterceptor=[action:this.&beforeInterceptorAction]
	
	private beforeInterceptorAction = {
		pars = utilService.getParams(request?.queryString)
	}
	def company(){
		def companies=Company.list();
		def currencySource	=	lkupTypeService.getLkupsByGroupId(Constants.LKP_GROUP_TYPE_CUR_TYPE, 'sortOrder')
		def isReadOnly		=	accountingService.isReadOnly(securityService.getAuthenticatedUser())
		
		[
			cmpnies:companies,
			currencySource:currencySource,
			isReadOnly:isReadOnly
		]
		
	}
	
	def save(){
		def jsonData
		def loggedUser		=	securityService.getAuthenticatedUser()
		def company	=	accountingService.save(params, loggedUser.id)
		
		if(grailsApplication.isDomainClass(company.getClass())) {
			def glAcc = accountingService.saveCompanyGLAccount(params, company, loggedUser)
			session['pageInfoMessage'] =  (params?.id) ? session['pageInfoMessage'] = messageService.getMessage(Constants.UPDATE_SUCCESS_MESSAGE,"Company ${company.companyName}",'')
					: messageService.getMessage(Constants.SAVE_SUCCESS_MESSAGE,"Company ${company.companyName}",'')
			jsonData = [
				status:'Success',
				nextUrl: createLink(controller: 'accounting', action: 'company')
			]
		}else {
			jsonData = [
				status : 'Failure',
				pageErrorMessage: Constants.FAILURE_MESSAGE,
				fieldErrorMessages: company
			]
		}
		render(jsonData as JSON)
	}
	
	def getCompany(){
		def companyDetails = accountingService.getCompanyDetails(params.compId) 
		render companyDetails as JSON
		
	}
	
	def contractTerms(){
		def contractMappingSource= lkupTypeService.getLkupsByGroupId(Constants.LKP_GROUP_TYPE_CONTRACT_MAPPING, 'sortOrder')
		def	contractTermsSource	=	lkupTypeService.getLkupsByGroupId(Constants.LKP_GROUP_TYPE_CONTRACT_TERMS, 'sortOrder')
		def isReadOnly		=	accountingService.isReadOnly(securityService.getAuthenticatedUser())
		[
			contractTermsSource		:	contractTermsSource,
			contractMappingSource	:	contractMappingSource ,
			isReadOnly				:	isReadOnly
		]
		
	}
	
	def saveContractMappings(){
		
		def jsonData
		def loggedUser		=	securityService.getAuthenticatedUser()
		def contractResult	=	accountingService.saveContractMappings(params, loggedUser.id)
		def contractName	= 	LkupType.findById(params?.contractTermId)
		if(grailsApplication.isDomainClass(contractResult.getClass())) {
			session['pageInfoMessage'] =  (params?.contractTermId) ? session['pageInfoMessage'] = messageService.getMessage(Constants.UPDATE_SUCCESS_MESSAGE,"Contract ${contractName.description}",'')
					: messageService.getMessage(Constants.SAVE_SUCCESS_MESSAGE,'Contract','')
			jsonData = [
				status:'Success',
				nextUrl: createLink(controller: 'accounting', action: 'contractTerms')
			]
		}
		render jsonData as JSON
		
	}
	
	def getContractMapping(){
		def contractData=[:]
		def  contTerms = LkupType.findById(params?.contractTermId as int)
		def contractMappingSource= lkupTypeService.getLkupsByGroupId(Constants.LKP_GROUP_TYPE_CONTRACT_MAPPING, 'sortOrder')
		def result=accountingService.getContractValues(params?.contractTermId)
		contractData.put('contractMappingSource', contractMappingSource)
		contractData.put('result', result)
		contractData.put('contTerms', contTerms)
		render contractData as JSON
	}
	
	def expenseTypes(){
	
	//	def expenseTypesSource	=	lkupTypeService.getLkupsByGroupId(Constants.LKP_GROUP_TYPE_PRJ_EXPENSES, 'sortOrder')
		def expenseTypesSource= LkupType.findAllByLkupTypeGroup(LkupTypeGroup.findById(Constants.LKP_GROUP_TYPE_PRJ_EXPENSES), [sort: "isActive", order: "desc"])
		def expenseMappingSource= lkupTypeService.getLkupsByGroupId(Constants.LKP_GROUP_TYPE_EXPENSES_MAPPING, 'sortOrder')
		def isReadOnly		=	accountingService.isReadOnly(securityService.getAuthenticatedUser())
		[
			expenseTypesSource		:	expenseTypesSource,
			expenseMappingSource	:	expenseMappingSource,
			isReadOnly				:	isReadOnly
		]
		
	}
	
	def saveExpenseMappings(){
		def jsonData
		def loggedUser		=	securityService.getAuthenticatedUser()
		def expenseResult	=	accountingService.saveExpenseMappings(params, loggedUser.id)
		def expenseName	= 	LkupType.findById(params?.expenseTypeId)
		if(grailsApplication.isDomainClass(expenseResult.getClass())) {
			session['pageInfoMessage'] =  (params?.expenseTypeId) ? session['pageInfoMessage'] = messageService.getMessage(Constants.UPDATE_SUCCESS_MESSAGE,"Expense ${expenseName.lkupName}",'')
					: messageService.getMessage(Constants.SAVE_SUCCESS_MESSAGE,'Expense','')
			jsonData = [
				status:'Success',
				nextUrl: createLink(controller: 'accounting', action: 'expenseTypes')
			]
		}
		render jsonData as JSON
		
	}
	
	def getExpenseMapping(){
		def expenseData=[:]
		def expenseMappingSource= lkupTypeService.getLkupsByGroupId(Constants.LKP_GROUP_TYPE_EXPENSES_MAPPING, 'sortOrder')
	
		def result=accountingService.getExpenseValues(params.expenseTypeId)
		expenseData.put('expenseMappingSource', expenseMappingSource)
		expenseData.put('result', result)
		render expenseData as JSON
	}
	
	def deleteAccount(){
		def jsonData
		def pgMsg
		def fldMsg
	
		def loggedUser = session['PROAPPUSER'].getId()		
		
		def isDelAcc = accountingService.deleteAccount(params)
		
		if(isDelAcc) {
			jsonData = [
				status:'Success',
				successMessage:messageSource.getMessage(Constants.ACCOUNT_DELETION_SUCCESS, [null] as Object[], '', Locale.US)]
		} else {
			jsonData = [
				status:'Failure',
				pageErrorMessage: messageSource.getMessage(Constants.ACCOUNT_DELETION_FAILURE,[null] as Object[],'',  Locale.US)]
		}
		render(jsonData as JSON)
	}
	
	def costCenters() {
		
		def companies=Company.list();
		[
			'comps' : companies
		]
	}
	
	def getCostCenters(){
		def costCenterId, childCostCenters
		def isFullTree = false
		def showDisabledStates = pars?.showDisabled ? true : false
		def enableFor =pars?.enableFor ? pars.enableFor : null
		if(pars.parentId != "#") {
			costCenterId = CompanyCostCenter.findById(pars.parentId)
		} else {
			if(pars?.isFullHierarchy && pars.isFullHierarchy == 'true'){
				isFullTree = true
			}
		}

		if(isFullTree){
			childCostCenters = accountingService.getCostCenterFullHierarchy(showDisabledStates,enableFor)
		}else{
			childCostCenters = accountingService.getChildCostCenters(showDisabledStates,costCenterId,enableFor)
		}
				
		render(childCostCenters as JSON)
	}
	
	def getCostCenterUpwardHierarchy() {
		
		def costCenterId
		
		if(pars.parentId != "#") {
			costCenterId = CompanyCostCenter.findById(pars.parentId)
		} else {
			  costCenterId = CompanyCostCenter.findById(pars.resId.toInteger())
		}
		def parentResources = accountingService.getParentCostCenters(costCenterId)
		
		if(pars?.op && pars.op == 'path'){
			parentResources = parentResources.take(parentResources.size()-1).id
		}
		else{
			parentResources = parentResources.take(parentResources.size()).id
		}
				
		render(parentResources as JSON)
	}
	
	def getFilterCostCenters() {
		def resources = accountingService.getFilterCostCenters(utilService.getParams(request?.queryString));
		render(contentType: 'text/json') {resources}
	}
	
	def getCostCenterDetails() {
		def costCenter
		def costCenterDtls
		def costCenterId
		def result = [:]
		def companyCostCenterName
		if(params?.costCenterId) {
			costCenterId = CompanyCostCenter.findById(params?.costCenterId)
			companyCostCenterName= costCenterId?.company?.companyName
			result['costCenter'] = costCenterId
			result['companyCostCenterName']=companyCostCenterName
			result['costCenterDtls'] = accountingService.getParentCostCenterDetails(costCenterId)
		}
		result['ccGLMappingSource'] = lkupTypeService.getLkupsByGroupId(Constants.LKP_GROUP_TYPE_COST_CENTER_GL_ACC_MAPPING, 'sortOrder')
		result['ccARMappingSource'] = lkupTypeService.getLkupsByGroupId(Constants.LKP_GROUP_TYPE_COST_CENTER_AR_ACC_MAPPING, 'sortOrder')
		result['status'] = 'Success'
		render result as JSON
	}
	
	def saveConCenterDtls(){
		def jsonData
		
		def loggedUser	=	securityService.getAuthenticatedUser()
		def cmpCC		=	accountingService.saveCostCeter(params, loggedUser.id)
		
		if(grailsApplication.isDomainClass(cmpCC.getClass())) {
			accountingService.saveConCenterDtls(params, cmpCC, loggedUser)
			session['pageInfoMessage'] = (params?.id) ? session['pageInfoMessage'] = messageService.getMessage(Constants.UPDATE_SUCCESS_MESSAGE,"Company ${cmpCC.costCenterName}",'')
			: messageService.getMessage(Constants.SAVE_SUCCESS_MESSAGE,"Company ${cmpCC.costCenterName}",'')
			jsonData = [
				status:'Success',
				nextUrl: createLink(controller: 'accounting', action: 'costCenters')
			]
		}else {
			jsonData = [
				status : 'Failure',
				pageErrorMessage: Constants.FAILURE_MESSAGE,
				fieldErrorMessages: cmpCC
			]
		}
		render(jsonData as JSON)
	}
	
	def resourceCostCenters(){
		def userObj
		def parse = getParseParams(params)
		userObj = User.findById(session['PROAPPUSER'].getId())
		def resourceObj = Resource.findByUser(userObj)
		def res = [
			"id"   : resourceObj?.id,
			"label": userObj.firstName+' '+userObj.lastName+ ' (' + resourceObj?.employeeNumber + ')'
		]
		res = res as JSON
		def isPmAndAbove = allocationService.isPmAndAbove(session['PROAPPUSER'].getId())
		[	res 			:	res.encodeAsJavaScript(),
			isPmAndAbove 	:	isPmAndAbove.userExists[0]	
		]
	}
	 
	def getParseParams(params) {
		log.debug("Params :: " + params)
		
		def parse
		String line = null

		BufferedReader reader = request.getReader()

		line = reader.readLine()

		if(line) {
			log.debug("Parameters missing")
			
			parse = utilService.getParams(line)
			
			log.debug("Parse :: " + parse)
		} else {
			log.debug("Parameters not missing")
		
			parse = params
		}

		return parse
	}
	
	def saveResourceCostCenters(){
		def jsonData
		def saveCostCenters= accountingService.saveResourceCostCenters(params)

		if(grailsApplication.isDomainClass(saveCostCenters.getClass())) {
			
			jsonData = [
				status:'Success',
				nextUrl: createLink(controller: 'accounting', action: 'resourceCostCenters'),
				pageMessageInfo:'Resource Cost Center updated Successfully'
			]
		}else {
			jsonData = [
				status : 'Failure',
				pageErrorMessage: Constants.FAILURE_MESSAGE,
				fieldErrorMessages: saveCostCenters
			]
		}
		render(jsonData as JSON)
	}
}
