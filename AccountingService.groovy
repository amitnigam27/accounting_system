package com.prolifics.ppmweb

import grails.converters.JSON
import grails.transaction.Transactional
import java.util.concurrent.CopyOnWriteArrayList

import org.hibernate.criterion.CriteriaSpecification
import com.prolifics.ppmweb.commons.core.LkupType
import com.prolifics.ppmweb.commons.core.UserRoleType
import com.prolifics.ppmweb.commons.core.base.ObjectRole
import com.prolifics.ppmweb.constant.Constants
import groovy.sql.Sql

@Transactional
class AccountingService {

  def messageService
  def dataSource

    def save(params, loggedUserId) {
	
		
		def parse = JSON.parse(params?.saveObj)
		def companyDtls = parse.companyDtls
		
		def company
		def companyResult
		def errExists
		def errMsg = [:]

		if(!companyDtls.id.equals(null)){
			company = Company.findById(companyDtls?.id as int)
			company.updatedBy = loggedUserId as int
		}
		else{
			company=new Company()
			company.createdBy=loggedUserId as int
		}
			
		company.companyName		= companyDtls?.companyName == '' ? null : companyDtls?.companyName			
		company.companyId		= companyDtls?.companyId == '' ? null : companyDtls?.companyId
		company.currencyId		= companyDtls?.currencyId == '' ? null : LkupType.findById(companyDtls?.currencyId as int)
		company.isMasterCompany = companyDtls?.isMasterCompany 
		
		if(!company.validate()) {
			errExists = true
			errMsg = messageService.getErrorMessage(company)
		}
		if(errExists) {
			return errMsg
		} else {
			companyResult = company.save(flush:true)
			return companyResult
		}
    }
	
	def getCompanyDetails(compId){

		def result =[:]
		def company = Company.findById(compId)
		
		def companies = Company.createCriteria().list{
			ne('id', compId.toInteger())
		}

		def glAccounts = CompanyGLAccount.createCriteria().list{
			resultTransformer(CriteriaSpecification.ALIAS_TO_ENTITY_MAP)
			createAlias("company", "company")
			projections{
				property('id', 'id')
				property('company', 'source')
				property('companyGLAccount', 'companyGLAccount')
				property('costCenter', 'costCenter')
				property('glAccount', 'glAccount')
			}
			eq('glAccountCompanyType',LkupType.findById(Constants.LKP_TYPE_COMPANY_GL_ACC))
			eq('company',company)
			
		}
		
		def foreignGlAccs = CompanyGLAccount.createCriteria().list{
			resultTransformer(CriteriaSpecification.ALIAS_TO_ENTITY_MAP)
			createAlias("company", "company")
			projections{
				property('id', 'id')
				property('company', 'source')
				property('company', 'companyGLAccount')
				property('costCenter', 'costCenter')
				property('glAccount', 'glAccount')
			}
			eq('glAccountCompanyType',LkupType.findById(Constants.LKP_TYPE_OTHER_COMPANY_GL_ACC))
			eq('companyGLAccount',company)
			
		}
		
		def otherGLAccounts = CompanyGLAccount.createCriteria().list{
			resultTransformer(CriteriaSpecification.ALIAS_TO_ENTITY_MAP)
			createAlias("company", "company")
			projections{
				property('id', 'id')
				property('company', 'source')
				property('companyGLAccount', 'companyGLAccount')
				property('costCenter', 'costCenter')
				property('glAccount', 'glAccount')
			}
			eq('glAccountCompanyType',LkupType.findById(Constants.LKP_TYPE_OTHER_COMPANY_GL_ACC))
			eq('company',company)
		}
		
		def otherForeignGLAccs = CompanyGLAccount.createCriteria().list{
			resultTransformer(CriteriaSpecification.ALIAS_TO_ENTITY_MAP)
			createAlias("company", "company")
			projections{
				property('id', 'id')
				property('company', 'source')
				property('company', 'companyGLAccount')
				property('costCenter', 'costCenter')
				property('glAccount', 'glAccount')
			}
			eq('glAccountCompanyType',LkupType.findById(Constants.LKP_TYPE_COMPANY_GL_ACC))
			eq('companyGLAccount',company)
		}
		
		result['companyDtls'] = company
		result['companies'] = companies
		result['glAccounts'] = foreignGlAccs+glAccounts
		result['otherGLAccounts'] = otherForeignGLAccs+otherGLAccounts
		
		return result
			
	}
	
	def saveContractMappings(params,loggedUserId){
		def contractMapping
		def contractResult
		def cntrctMapping
		def formData=JSON.parse(params.dataObj);
		def contract = ContractMapping.findByContractTermId(LkupType.findById(params?.contractTermId as int))
		
			formData.each { key,value->
				if(contract!=null){
					cntrctMapping = ContractMapping.findByContractTermIdAndContractMappingId(LkupType.findById(params?.'contractTermId' as int), LkupType.findById(key as int))
					cntrctMapping.updatedBy = loggedUserId as int
				}
				else{
					cntrctMapping=new ContractMapping()
					cntrctMapping.createdBy				=	loggedUserId as int
				}
				cntrctMapping.contractTermId		=	LkupType.findById(params.contractTermId as int)
				cntrctMapping.contractMappingId		=	LkupType.findById(key as int)
				cntrctMapping.glAccount				=	(value == '') ? null : value as int
				contractResult 						= 	cntrctMapping.save(flush:true)
			}
		return contractResult
		}
	
	 def getContractValues(contractTermId){
		 	def result=ContractMapping.createCriteria().list{
				 projections{
					 property('contractMappingId.id')
					 property('glAccount')
				 }
				 eq('contractTermId', LkupType.findById(contractTermId as int))
				 
			 }		
			 def contractMap=[:]
			 result.each{it-> 
				 contractMap[it[0]]=it[1]
			 }
			 return contractMap
	 }
	 
	 
	 def saveExpenseMappings(params,loggedUserId){
		 def expenseMapping
		 def expenseResult
		 def expnsetMapping
		 def formData=JSON.parse(params.dataObj);
		 
		 def expense = ExpenseMapping.findByExpenseTypeId(LkupType.findById(params?.expenseTypeId as int))
				 
		 formData.each { key,value->
			 if(expense!=null){
				 expnsetMapping						=	ExpenseMapping.findByExpenseTypeIdAndExpenseMappingId(LkupType.findById(params?.'expenseTypeId' as int), LkupType.findById(key as int))
				 expnsetMapping.updatedBy 			= 	loggedUserId as int
			 }else{
			 	expnsetMapping=new ExpenseMapping()
				expnsetMapping.createdBy			=	loggedUserId as int
			 }
			 
			 expnsetMapping.expenseTypeId			=	LkupType.findById(params.expenseTypeId as int)
			 expnsetMapping.expenseMappingId		=	LkupType.findById(key as int)
			 expnsetMapping.glAccount				=	(value == '') ? null : value as int
			 expenseResult 							= 	expnsetMapping.save(flush:true)
		 }
		 return expenseResult
	 }
	 
	 
	def getExpenseValues(expenseTypeId){
			def result=ExpenseMapping.createCriteria().list{
					projections{
						property('expenseMappingId.id')
						property('glAccount')
					}
					eq('expenseTypeId', LkupType.findById(expenseTypeId as int))
		
				}
				def expenseMap=[:]
				result.each{it->
					expenseMap[it[0]]=it[1]
				}
				return expenseMap
	}
	
	def isReadOnly(user){
		
		def readOnly = UserRoleType.createCriteria().list{
			projections{
				property('roleType')
			}
			eq('user', user)
			eq('roleType.id', Constants.FM_ADMIN_GROUP)
			
		}
		if(readOnly.size() > 0) {
			readOnly = false
			
		} 
		else{
			readOnly = ObjectRole.createCriteria().list{
				projections{
					property('objectTypeRoleType')
				}
				eq('user', user)
				eq('object', -1)
				'in'('objectTypeRoleType.id', Constants.PRJ_READ_ONLY_OBJ_TYP_ROLE)
			}
			if(readOnly.size() > 0){
				readOnly = true
				
			}
			else {
			readOnly = false
			
			}
		}
		
		return readOnly
	}
	

	 
	def saveCompanyGLAccount(params, company, user){
		def parse = JSON.parse(params?.saveObj)
		def accounts = parse.accounts
		def result

		accounts.each{
			def account = Company.findById(it?.accountId as int)
			def glAccountType = LkupType.findById(it?.accountType as int)
			
			def cmpnyGlAcc = CompanyGLAccount.findByCompanyAndGlAccountCompanyTypeAndCompanyGLAccount(company, glAccountType, account)
			
			if(!cmpnyGlAcc){
				cmpnyGlAcc = new CompanyGLAccount()
				cmpnyGlAcc.company = company
				cmpnyGlAcc.glAccountCompanyType = glAccountType
				cmpnyGlAcc.companyGLAccount = account
				cmpnyGlAcc.createdBy = user
			} 
			
			cmpnyGlAcc.costCenter = (it?.costCenter.trim() == '') ? null : it.costCenter
			cmpnyGlAcc.glAccount = (it?.glAcc == 0) ? null : it?.glAcc as Integer
			cmpnyGlAcc.updatedBy = user
			result = cmpnyGlAcc.save(flush:true)
		}
		
		return result
	}
	
	def deleteAccount(parse){
		def account = CompanyGLAccount.findById(parse?.accountId as int)
		
		CompanyGLAccount.where{
			eq('company',account.company)
			eq('companyGLAccount',account.companyGLAccount)
		}.deleteAll()
		
		return true
	}
	
	def getCostCenterFullHierarchy(showDisabledStates,enableFor){
		def resourceData = []
		def res = CostCenterHierarchyView.createCriteria().list{
			
			isNull("parentId")
			order("costCenterName", "asc")
		}
		
		res.each{cr ->
			def resMap = [:]
			resMap.put("id", cr?.id)
			resMap.put("text", cr?.costCenterName)
			resMap.put("children", (cr?.hasChilds == 1) ? true : false)
			
			if(showDisabledStates){
				if(enableFor=='engagement')
					resMap.put("state", cr?.isEnableForEngagements ? ['opened':true] : ['disabled':true])
				if(enableFor=='resource')
					resMap.put("state", cr?.isEnableForResource ? ['opened':true] : ['disabled':true])
			}
			log.debug("child resource map :: " + resMap);
			
			resourceData.add(resMap)
		}
		
		return resourceData
	}
	
	def getChildCostCenters(showDisabledStates, costCenterId,enableFor){
		def childCostCenters
		def resourceData = [];
		def resourceDataFin = [:];
		
		def costCenterName =  costCenterId?.costCenterName
		costCenterName = costCenterName.replace('  ',' ')
		def resourceMap = [:]
		def openedState = ['opened': true], disabledState = ['disabled': true]
		
		childCostCenters = CostCenterHierarchyView.createCriteria().list{
			and{
				eq("parentId", costCenterId?.id)
			}
			order("costCenterName", "asc")
		}
		
		log.debug("child resources :: " + childCostCenters)
		
		childCostCenters?.each{cr->
			def childCCMap = [:]
			
			childCCMap.put("id", cr?.id)
			childCCMap.put("text", cr?.costCenterName)
			childCCMap.put("children", (cr?.hasChilds == 1) ? true : false)
			
			if(showDisabledStates){
				if(enableFor=='engagement')
					childCCMap.put("state", cr?.isEnableForEngagements ?  ['opened': false] : disabledState)
				if(enableFor=='resource')
					childCCMap.put("state", cr?.isEnableForResource ?  ['opened': false] : disabledState)
			}
			log.debug("child resource map :: " + childCCMap);
			
			resourceData.add(childCCMap)
		}

		resourceDataFin.put("id", costCenterId?.id)
		resourceDataFin.put("text", costCenterName)
		resourceDataFin.put('children', resourceData)
		
		if(showDisabledStates){
			if(enableFor=='engagement')
				resourceDataFin.put("state", costCenterId?.isEnableForEngagements ? openedState : disabledState)
			if(enableFor=='resource')
				resourceDataFin.put("state", costCenterId?.isEnableForResource ? openedState : disabledState)
		}else
			resourceDataFin.put("state", openedState)
		
		log.debug("resourceDataFin - Child::"+resourceDataFin)
		return resourceDataFin
	}
	
	def getParentCostCenters(resource){
		
		Sql sql =  new Sql(dataSource)
		log.error('CALL getCostCenterUpwardHierarchy(${resource?.id})')
		def parentInfo = sql.rows("CALL getCostCenterUpwardHierarchy(${resource?.id})")
		sql.close();
		
		if(parentInfo[0].parent == null){
			parentInfo[0].parent = '#'
		}
		
		return parentInfo
	}
	
	def getFilterCostCenters(searchParams) {
		List resourceList = new ArrayList()
		
		def resources = CompanyCostCenter.createCriteria().list {
			projections {
				distinct('id')
				property('costCenterName')
			}
			or {
				like('costCenterName', "%"+searchParams.term+"%")
			}
			eq("isActive", true)
			order('costCenterName','asc')
		}
		
		resources.eachWithIndex{Resource, idx ->
			def name = Resource[1]
			name = name.replace('  ',' ')
			def cust = [
				"id"   : Resource[0],
				"label": name
			]
			resourceList.add(cust);
		}
		
		return resourceList;
	}
	
	def getParentCostCenterDetails(costCenteId) {
		List glAccList = new ArrayList()
		List arAccList = new ArrayList()
		def result = [:]
		  
		def ccDtls = CostCenterAccountDtl.createCriteria().list {
			resultTransformer(CriteriaSpecification.ALIAS_TO_ENTITY_MAP)
			createAlias('costCenter','costCenter')
			createAlias('accountId','account')
			createAlias('account.lkupTypeGroup','grp')
			projections {
				property('id','id')
				property('costCenterValue','costCenterValue')
				property('accountValue','accountValue')
				property('account.lkupName','lkupName')
				property('account.id','lkupId')
				property('grp.id','grpId')
			}
			eq("account.isActive", true)
			eq("costCenter", costCenteId)
			order('account.sortOrder','asc')
		}
		 
		ccDtls.each{
			if(it.grpId == Constants.LKP_GROUP_TYPE_COST_CENTER_GL_ACC_MAPPING) {
				def act = [
					"id"   : it.id,
					"lkupName": it.lkupName,
					"lkupId": it.lkupId,
					"accountValue" :it.accountValue,
					"costCenterValue" : it.costCenterValue
				]
				glAccList.add(act);
			} else {
				def act1 = [
					"id"   : it.id,
					"lkupName": it.lkupName,
					"lkupId": it.lkupId,
					"accountValue" :it.accountValue,
					"costCenterValue" : it.costCenterValue
				]
				arAccList.add(act1);
			}
		}
		result['glAcc'] = glAccList;
		result['arAcc'] = arAccList;
		log.error("Service Result ::::::"+result);
		return result;
	}
	
	def saveCostCeter(params, user) {
		def cmpCC
		def result
		def errExists
		def errMsg
		def parse = JSON.parse(params?.saveObj)
		def comp =(parse?.companyDtls?.ccCompany == 'null') ? null :  Company.findById(parse?.companyDtls?.ccCompany as int)
		
		
		log.error("params:::"+comp);
		if(parse?.companyDtls?.saveType == 'New') {
			cmpCC = new CompanyCostCenter()
			cmpCC.createdBy = user
			cmpCC.parentId = parse?.companyDtls?.costCenterId as int
		} else {
			cmpCC	=  CompanyCostCenter.findById(parse?.companyDtls?.costCenterId)
		}
		cmpCC.costCenterName 			= 	parse?.companyDtls?.ccName.trim() == "" ? null : parse?.companyDtls?.ccName.trim()
		cmpCC.costCenterNumber 			= 	parse?.companyDtls?.ccNumber.trim() == "" ? null : parse?.companyDtls?.ccNumber.trim()
		cmpCC.company 					= 	comp
		cmpCC.isEnableForResource 		= 	parse?.companyDtls?.isEnableRes
		cmpCC.isEnableForEngagements 	= 	parse?.companyDtls?.isEnableEngg
		cmpCC.isActive			 		= 	1
		if(parse?.companyDtls?.saveType == 'Edit')
			cmpCC.updatedBy	=  user
		if(!cmpCC.validate()) {
			errExists = true
			errMsg = messageService.getErrorMessage(cmpCC)
			log.error(errMsg)
		}
		if(errExists) {
			return errMsg
		} else {
			result = cmpCC.save(flush:true)
			return result
		}
		 
	}
	
	def saveConCenterDtls(params, costCenter, user){
		def parse = JSON.parse(params?.saveObj)
		def accounts = parse.accounts
		def result
		accounts.each{
		
			def AccountType = LkupType.findById(it?.lkupId as int)
			def cmpnyAcc = CostCenterAccountDtl.findByCostCenterAndAccountId(costCenter, AccountType)
			
			if(!cmpnyAcc){
				cmpnyAcc = new CostCenterAccountDtl()
				cmpnyAcc.costCenter = costCenter
				cmpnyAcc.accountId = AccountType
				cmpnyAcc.createdBy = user.id
			}
			
			cmpnyAcc.costCenterValue = it?.costCenter
			cmpnyAcc.accountValue = it?.glAcc
			cmpnyAcc.updatedBy = user.id
			result = cmpnyAcc.save(flush:true)
		}
		
		return result
	}

	
	def saveResourceCostCenters(params){
		def costCenterResult
		
		def resObj= Resource.findById(params?.resId)
		resObj.costCenter = CompanyCostCenter.findById(params?.costCenterId)
		costCenterResult = resObj.save(flush:true)
		
		return costCenterResult
	}
}


