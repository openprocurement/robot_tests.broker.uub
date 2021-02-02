*** Settings ***
*** Settings ***
Library  String
Library  DateTime
Library  Selenium2Library
Library  Collections
Library  uub_service.py
Library  json

*** Variables ***
${locator.edit.description}  id=ePosition_description
${locator.title}  id=tePosition_title
${locator.description}  id=tePosition_description
${locator.minimalStep.amount}  id=tePosition_minimalStep_amount
${locator.value.amount}  id=tePosition_value_amount
${locator.value.valueAddedTaxIncluded}  id=cbPosition_value_valueAddedTaxIncluded
${locator.value.currency}  id=tslPosition_value_currency
${locator.enquiryPeriod.startDate}  id=tdtpPosition_enquiryPeriod_startDate_Date
${locator.enquiryPeriod.endDate}  id=tdtpPosition_enquiryPeriod_endDate_Date
${locator.tenderPeriod.startDate}  id=tdtpPosition_tenderPeriod_startDate_Date
${locator.tenderPeriod.endDate}  id=tdtpPosition_tenderPeriod_endDate_Date

*** Keywords ***
Підготувати клієнт для користувача
  [Arguments]  ${username}
  Open Browser  ${BROKERS['uub'].login_page}  ${USERS.users['${username}'].browser}  alias=${username}
  Set Window Size  @{USERS.users['${username}'].size}
  Set Window Position  @{USERS.users['${username}'].position}
  Login  ${username}
  Set Global Variable  ${first_search}  ${TRUE}
  Set Global Variable  ${need_reg_criteria}  ${FALSE}
  
Підготувати дані для оголошення тендера
  [Arguments]  ${username}  ${tender_data}  ${role_name}
  ${adapted_data}=  Run keyword if  '${role_name}' == 'tender_owner'  adapt_owner  ${tender_data}
  ...  ELSE  Set Variable  ${tender_data}
  
##  ${funders}=  Run Keyword And Return Status  Dictionary Should Contain Key  ${tender_data.data}  funders
##  ${adapted_data}=  Run Keyword If  ${funders}  adapt_funder  ${adapted_data}  
##  ...  ELSE  Set Variable  ${adapted_data}

  [Return]  ${adapted_data}

Login
  [Arguments]  @{ARGUMENTS}
  Input text  id=eLogin  ${USERS.users['${ARGUMENTS[0]}'].login}
  Click Button  id=btnLogin
  Sleep  2

Змінити користувача
  [Arguments]  @{ARGUMENTS}
  Go to  ${USERS.users['${ARGUMENTS[0]}'].homepage}
  Sleep  2
  Input text  id=eLogin  ${USERS.users['${ARGUMENTS[0]}'].login}
  Click Button  id=btnLogin
  Sleep  2
  
Оновити сторінку з планом
  [Arguments]   ${username}    ${tender_uaid}
  Reload Page

Пошук плану по ідентифікатору
  [Arguments]  ${username}  ${tender_uaid}
  Switch Browser  ${username}
  go to  ${BROKERS['uub'].plans_page}
  Wait Until Page Contains Element  id=btFilterNumber
  ${has_filter}=  Run Keyword And Return Status    Element Should Not Be Visible    id=ew_fv_0_value
  Run Keyword If  ${has_filter}  Click Element  id=btFilterNumber
  Click Element  id=btFilterNumber
  Wait Until Page Contains Element  id=ew_fv_0_value
  Input Text  id=ew_fv_0_value  ${tender_uaid}
  Click Element  id=btnFilter
  Wait Until Page Contains Element  xpath=(//a[contains(text(), '${tender_uaid}')])
  Sleep  1
  
  Click Element  xpath=(//a[contains(text(), '${tender_uaid}')])
  Wait Until Element Contains  id=page_shown  Y  10
  
Створити план
  [Arguments]  ${username}  ${plan_data}
  go to  ${BROKERS['uub'].plans_page}
  Wait Until Page Contains Element  id=btAddRecord  20
  Click Element  id=btAddRecord
  Wait Until Element Contains  id=page_shown  Y  10
  ${procurement_method_type}=  Get From Dictionary  ${plan_data.data.tender}  procurementMethodType
  Set Global Variable  ${procurement_method_type}
  Wait Until Page Contains Element  id=btnSend  20
  Select From List By Value  id=slPosition_procurementMethodType  ${plan_data.data.tender.procurementMethodType}
  Input text  xpath=//*[@id='pn_PE_place']//*[@name="name"]  ${plan_data.data.procuringEntity.name}
  Input text  xpath=//*[@id='pn_PE_place']//*[@name="identifier.legalName"]  ${plan_data.data.procuringEntity.name}
  Input text  xpath=//*[@id='pn_PE_place']//*[@name="identifier.id"]  ${plan_data.data.procuringEntity.identifier.id}

  створити план для процедури  ${username}  ${plan_data}  ${procurement_method_type}
  
  CLICK ELEMENT  id=btnSend
  Wait Until Page Contains  Збереження виконано  20
  Click Element  id=btnPublic
  Wait Until Page Contains  Публікацію виконано  20
  ${tender_uaid}=  get text  id=tPosition_planID
  
  [Return]  ${tender_uaid}

створити план для процедури
  [Arguments]  ${username}  ${plan_data}  ${procurement_method_type}
  Input Text  id=ePosition_description  ${plan_data.data.budget.description}
  ${amount}=  Convert To String  ${plan_data.data.budget.amount}
  Input Text  id=ePosition_value_amount  ${amount}
  ${period_startDate}=  convert_ISO_Y  ${plan_data.data.budget.period.startDate}
  Input Text  id=ePosition_period_startDate_year  ${period_startDate}
  ${period_endDate}=  convert_ISO_Y  ${plan_data.data.budget.period.endDate}
  Input Text  id=ePosition_period_endDate_year  ${period_endDate}
  input text  id=ePosition_classification_id  ${plan_data.data.classification.id}
  Sleep  1
  Wait Until Page Contains Element  xpath=(//ul[contains(@class, 'ui-autocomplete') and not(contains(@style,'display: none'))]//li//a)
  Click Element  xpath=(//ul[contains(@class, 'ui-autocomplete') and not(contains(@style,'display: none'))]//li//a)

  ${items}=  Get From Dictionary  ${plan_data.data}  items
  ${number_of_items}=  Get Length  ${items}
  set global variable  ${number_of_items}
  :FOR  ${index}  IN RANGE  ${number_of_items}
  \  Click Element  id=btn_items_add
  \  Додати предмет плану  ${items[${index}]}  ${index}

  ${breakdowns}=  Get From Dictionary  ${plan_data.data.budget}  breakdown
  ${number_of_breakdowns}=  Get Length  ${breakdowns}
  set global variable  ${number_of_breakdowns}
  :FOR  ${index}  IN RANGE  ${number_of_breakdowns}
  \  Run Keyword If  '${index}' != '0'  Click Element  xpath=(//button[contains(text(), 'Додати джерело фінансування')])[last()]
  \  Додати джерело плану  ${breakdowns[${index}]}  ${index}

Внести зміни в план
  [Arguments]  ${username}  ${tender_uaid}  ${fieldname}  ${field_value}
  ${value}=  Run Keyword If  '${fieldname}' == 'budget.amount'  convert to string  ${field_value}
  ...  ELSE IF  '${fieldname}' == 'items[0].quantity'  convert to string  ${field_value}
  ...  ELSE IF  '${fieldname}' == 'items[0].deliveryDate.endDate'  convert_ISO_DMY  ${field_value}
  ${return_value}=  Run Keyword If  '${fieldname}' == 'budget.description'  input text  id=ePosition_description  ${field_value}
  ...  ELSE IF  '${fieldname}' == 'budget.amount'  input text  id=ePosition_value_amount  ${value}
  ...  ELSE IF  '${fieldname}' == 'items[0].quantity'  input text  id=ew_item_0_quantity  ${value}
  ...  ELSE IF  '${fieldname}' == 'items[0].deliveryDate.endDate'  input text  id=dtpw_item_0_deliveryDate_endDate_Date  ${value}
  ...  ELSE IF  '${fieldname}' == 'items[0].quantity'  input text  id=ew_item_0_quantity  ${value}

  click element  id=btnPublic
  [Return]  ${return_value}

Додати предмет закупівлі в план
  [Arguments]  ${username}  ${tender_uaid}  ${item_data}
  ${item_count}=  Get Matching Xpath Count  xpath=(//*[starts-with(@id, 'pn_w_item')])
  ${item_count}=  Convert To Integer  ${item_count}
  Click Element  id=btn_items_add
  Додати предмет плану  ${item_data}  ${item_count}
  click element  id=btnPublic

Додати предмет плану
  [Arguments]  ${item}  ${index}
  Input Text  id=ew_item_${index}_description  ${item.description}
  input text  id=ew_item_${index}_classification_id  ${item.classification.id}
  Sleep  1
  Wait Until Page Contains Element  xpath=(//ul[contains(@class, 'ui-autocomplete') and not(contains(@style,'display: none'))]//li//a)
  Click Element  xpath=(//ul[contains(@class, 'ui-autocomplete') and not(contains(@style,'display: none'))]//li//a)
  Run Keyword If  '${procurement_method_type}' != 'esco'  Додати не esco параметри предмету  ${item}  ${index} 
  
Додати не esco параметри предмету
  [Arguments]  ${item}  ${index}
  ${item_quantity}=  Convert To String  ${item.quantity}
  Input Text  id=ew_item_${index}_quantity  ${item_quantity}
  Select From List By Value  id=slw_item_${index}_unit_code  ${item.unit.code}
  ${endDate}=  convert_ISO_DMY  ${item.deliveryDate.endDate}  
  Input Text  id=dtpw_item_${index}_deliveryDate_endDate_Date  ${endDate}

Видалити предмет закупівлі плану
  [Arguments]  ${username}  ${tender_uaid}  ${item_id}  ${lot_id}=Empty
  Wait Until Element Is Visible  id=btnPublic  20
  click element  xpath=//*[contains(@class, '${item_id}')]//button[contains(@id, 'btn_item_delete')]
  click element  id=btnPublic

Додати джерело плану
  [Arguments]  ${breakdowns}  ${index}
  ${index}=  inc  ${index}
  Select From List By Value  xpath=(//div[contains(@id, 'Tender_breakdown_')][${index}]//select[contains(@id, '_title')])  ${breakdowns.title}
  ${breakdown_amount}=  Convert To String  ${breakdowns.value.amount}
  Input Text  xpath=(//div[contains(@id, 'Tender_breakdown_')][${index}]//input[contains(@id, '_value_amount')])  ${breakdown_amount}
  Input Text  xpath=(//div[contains(@id, 'Tender_breakdown_')][${index}]//textarea[contains(@id, '_description')])  ${breakdowns.description}

Отримати інформацію із плану
    [Arguments]  ${username}  ${tender_uaid}  ${fieldname}

  ${return_value}=  Run Keyword If  '${fieldname}' == 'tender.procurementMethodType'  Get Text  name=procurementMethodType
  ...  ELSE IF  '${fieldname}' == 'status'  Get Text  xpath=(//*[@name="status"])
  ...  ELSE IF  '${fieldname}' == 'procuringEntity.identifier.id'  Отримати інформацію з елементу за шляхом //*[@id='pn_PE_place']//*[@name="identifier.id"]
  ...  ELSE IF  '${fieldname}' == 'procuringEntity.name'  Отримати інформацію з елементу за шляхом //*[@id='pn_PE_place']//*[@name="name"]
  ...  ELSE IF  '${fieldname}' == 'procuringEntity.identifier.legalName'  Отримати інформацію з елементу за шляхом //*[@id='pn_PE_place']//*[@name="identifier.legalName"]
  ...  ELSE IF  '${fieldname}' == 'procuringEntity.identifier.scheme'  set variable  UA-EDR
  ...  ELSE IF  '${fieldname}' == 'budget.description'  Отримати інформацію з елементу за шляхом //*[@name="ePosition_description"]
  ...  ELSE IF  '${fieldname}' == 'budget.currency'  set variable  UAH
  ...  ELSE IF  '${fieldname}' == 'classification.description'  Отримати інформацію з елементу за шляхом //*[@name="ePosition_classification_description"]
  ...  ELSE IF  '${fieldname}' == 'classification.scheme'  set variable  ДК021
  ...  ELSE IF  '${fieldname}' == 'classification.id'  Отримати інформацію з елементу за шляхом //*[@name="ePosition_classification_id"]
  ...  ELSE IF  '${fieldname}' == 'items[0].description'  Отримати інформацію з елементу за шляхом //*[@id="pn_w_item_0"]//*[@name="description"]
  ...  ELSE IF  '${fieldname}' == 'items[0].quantity'  Отримати інформацію з елементу за шляхом //*[@id="pn_w_item_0"]//*[@name="quantity"]
  ...  ELSE IF  '${fieldname}' == 'items[0].unit.name'  Отримати інформацію з елементу за шляхом //*[@id="pn_w_item_0"]//*[@name="unit.name"]
  ...  ELSE IF  '${fieldname}' == 'items[0].classification.description'  Отримати інформацію з елементу за шляхом //*[@id="pn_w_item_0"]//*[@name="classification.description"]
  ...  ELSE IF  '${fieldname}' == 'items[0].classification.scheme'  set variable  ДК021
  ...  ELSE IF  '${fieldname}' == 'items[0].classification.id'  Отримати інформацію з елементу за шляхом //*[@id="pn_w_item_0"]//*[@name="classification.id"]
  ...  ELSE IF  '${fieldname}' == 'items[0].deliveryDate.endDate'  Отримати інформацію з елементу за шляхом //*[@id="pn_w_item_0"]//*[@name="deliveryDate.endDate"]

  ${return_value}=  Run Keyword If  '${fieldname}' == 'budget.amount'  Convert To Number  ${return_value.replace(' ', '').replace(',', '.')}
  ...  ELSE IF  '${fieldname}' == 'items[0].quantity'  Convert To Number  ${return_value.replace(' ', '').replace(',', '.')}
  ...  ELSE  Set Variable  ${return_value}

  [Return]  ${return_value}

################################## Тендер ######################################
  
Створити тендер
  [Arguments]  ${username}  ${tender_data}  ${plan_uaid}  ${article_17_data}=${None}
  go to  ${BROKERS['uub'].tenders_page}
  ${procurement_method_type}=  Get From Dictionary  ${tender_data.data}  procurementMethodType
  Set Global Variable  ${procurement_method_type}
  ${items}=  Get From Dictionary  ${tender_data.data}  items

  Wait Until Page Contains Element  id=btAddTender  20
  Click Element  id=btAddTender
  Wait Until Element Contains  id=page_shown  Y  10
  Select From List By Value  id=slPosition_procurementMethodType  ${tender_data.data.procurementMethodType}
  Wait Until Element Contains  id=page_shown  Y  10
  Input text  id=ePosition_planID  ${plan_uaid}
  Select From List By Value  id=slPosition_mainProcurementCategory  ${tender_data.data.mainProcurementCategory}

  ${procurementMethodDetails}=  Get From Dictionary  ${tenderData.data}  procurementMethodDetails
  Input Text  id=e_quick_value  ${accelerator}

  Input text  id=ew_Org_0_CP_name  ${tender_data.data.procuringEntity.contactPoint.name}
  Input text  id=ew_Org_0_CP_email  ${tender_data.data.procuringEntity.contactPoint.email}
  Input text  id=ew_Org_0_CP_telephone  ${tender_data.data.procuringEntity.contactPoint.telephone}
  Input text  id=ew_Org_0_CP_url  ${tender_data.data.procuringEntity.contactPoint.url}
  Input text  id=ew_Org_0_PE_identifier_id  ${tender_data.data.procuringEntity.identifier.id}
  Input text  id=ew_Org_0_PE_name  ${tender_data.data.procuringEntity.name}

  ${has_en}=  Evaluate  '${procurement_method_type}' in ['aboveThresholdEU', 'aboveThresholdUA.defense', 'competitiveDialogueEU', 'esco', 'closeFrameworkAgreementUA']
  Set Global Variable  ${has_en}
  ${has_auction}=  Evaluate  '${procurement_method_type}' in ['belowThreshold', 'aboveThresholdUA', 'aboveThresholdEU', 'aboveThresholdUA.defense', 'competitiveDialogueUA', 'competitiveDialogueEU', 'closeFrameworkAgreementUA']
  Set Global Variable  ${has_auction}
  
  Input text  id=ePosition_title  ${tender_data.data.title}
  Input text  id=ePosition_description  ${tender_data.data.description}

  Run Keyword If  ${has_en}  Run Keywords  Input text  id=ePosition_title_en  ${tender_data.data.title_en}
  ...  AND  Input text  id=ePosition_description_en  ${tender_data.data.description_en}

  ${str}=  Run Keyword If  ${has_auction}  Convert To String  ${tender_data.data.minimalStep.amount}
  Run Keyword If  ${has_auction}  input text  id=ePosition_minimalStep_amount  ${str}
  
  ${str}=  Run Keyword If  not '${procurement_method_type}' in ['esco']  Convert To String  ${tender_data.data.value.amount}
  Run Keyword If  not '${procurement_method_type}' in ['esco']  Run Keywords
  ...  Input text  id=ePosition_value_amount  ${str}
  ...  AND  Set global Variable  ${tender_data.data.value.valueAddedTaxIncluded}
  ...  AND  Run Keyword If  '${tender_data.data.value.valueAddedTaxIncluded}' == 'True'  Click Element  id=lcbPosition_value_valueAddedTaxIncluded
  ...  AND  Select From List By Value  id=slPosition_value_currency  ${tender_data.data.value.currency}
 
  Run Keyword If  not '${procurement_method_type}' in ['reporting', 'negotiation', 'negotiation_quick']  
  ...  Встановити tenderPeriod endDate  ${username}  ${tender_data}

  Run Keyword If  '${procurement_method_type}' == 'belowThreshold'  Доповнити belowThreshold  ${username}  ${tender_data}
  Run Keyword If  '${procurement_method_type}' in ['negotiation', 'negotiation_quick']  Доповнити negotiation  ${username}  ${tender_data}  ${plan_uaid}
  Run Keyword If  '${procurement_method_type}' == 'esco'  Доповнити esco  ${username}  ${tender_data}  ${plan_uaid}
  Run Keyword If  '${procurement_method_type}' == 'closeFrameworkAgreementUA'  Доповнити closeFrameworkAgreementUA  ${username}  ${tender_data}  ${plan_uaid}

  ${funders}=  Run Keyword And Return Status  Dictionary Should Contain Key  ${tender_data.data}  funders
  Run Keyword If  ${funders}  Run Keywords  
  ...  click element  id=lcb_funder_has
  ...  AND  sleep  1
  ...  AND  Select From List By Value  id=sl_funder_list  ${tender_data.data.funders[0].identifier.id}
  ...  AND  click element  id=bt_funder

  ${islot}=  Run Keyword And Return Status  Dictionary Should Contain Key  ${tender_data.data}  lots
  Set Global Variable  ${islot}
  Run Keyword If  ${islot} and '${procurement_method_type}' != 'closeFrameworkAgreementUA'  Run Keywords
  ...  Click Element  id=lcbWithLots
  ...  AND  Click Element  id=btn_lots_add
  ...  AND  Додати лот  ${tender_data.data.lots[0]}  0

  ${items}=  Get From Dictionary  ${tender_data.data}  items
  ${number_of_items}=  Get Length  ${items}
  :FOR  ${index}  IN RANGE  ${number_of_items}
  \  Click Element  xpath=//button[@data-atid="btn_items_add"]
  \  Додати предмет тендера  ${items[${index}]}  ${index}

  ${hasFeatures}=  Run Keyword And Return Status  Dictionary Should Contain Key  ${tender_data.data}  features
  Run Keyword If  ${hasFeatures}  Click Element  lcbWithFeatures
  ${number_of_features}=  Run Keyword If  ${hasFeatures}  Get Length  ${tender_data.data.features}
  ...  ELSE  convert to integer  0 
  set global variable  ${number_of_features}
  :FOR  ${index}  IN RANGE  ${number_of_features}
  \  Додати неціновий критерій  ${tender_data.data.features[${index}]}  

  ${number_of_milestones}=  Run Keyword If  not '${procurement_method_type}' in ['esco']  Get Length  ${tender_data.data.milestones}
  ...  ELSE  convert to integer  0
  :FOR  ${index}  IN RANGE  ${number_of_milestones}
  \  Click Element  xpath=//button[@data-atid="btn_milestones_add"]
  \  Додати умови оплати    ${tender_data.data.milestones[${index}]}   ${index}

  Run Keyword If  ${ARTICLE_17} == True  Додати критерії  ${article_17_data}

  Click Element  id=btnSend
  Sleep  1
  Wait Until Element Contains  id=ValidateTips  Збереження виконано  30
  ${tender_id}=  Get Text  id=tPosition_tenderID
 
  Click Element  id=btnPublic
  Wait Until Page Contains  Публікацію виконано  30
  ${TENDER}=  Get Text  id=tPosition_tenderID
  log to console  ${TENDER}
  ${need_copy_tender_data}=  Set variable  ${True}

  [return]  ${TENDER}

Створити тендер другого етапу
  [Arguments]  ${username}  ${tender_data}
  Log  ${tender_data}
  
  ${file_path}=  Get Variable Value  ${Tender_FILE}  artifact
  ${file_path}=  Set variable  ${file_path}.yaml
  
  ${ARTIFACT}=  load_data_from  ${file_path}
  Set Global Variable  ${tender_uaid}  ${ARTIFACT.tender_uaid}
  uub.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  Click Element  id=btn_FA_draft
 
  Wait Until Element Is Visible  id=btnSend
  Click Element  id=btnSend
  Sleep  1
  Wait Until Element Contains  id=ValidateTips  Збереження виконано  30
  Wait Until Element Contains  id=page_shown  Y  10
  Input text  id=ew_Org_0_CP_url  ${tender_data.data.procuringEntity.contactPoint.url}

  ${tender_id}=  Get Text  id=tPosition_tenderID
 
  Click Element  id=btnPublic
  Wait Until Page Contains  Публікацію виконано  30
  ${TENDER}=  Get Text  id=tPosition_tenderID
  log to console  ${TENDER}
  Set Global Variable  ${need_reg_criteria}
  Set Global Variable  ${first_search}  ${TRUE}
  
  [return]  ${TENDER}
  
Створити тендер з критеріями
  [Arguments]  ${username}  ${tender_data}  ${plan_uaid}  ${article_17_data}
  ${TENDER}=  uub.Створити тендер  ${username}  ${tender_data}  ${plan_uaid}  ${article_17_data}

  log  ${USERS.users['${tender_owner}'].tender_data}
  ${criterias}=  Get text  id=criteria_contennt
  ${criterias}=  json_load  ${criterias}
  Set Global Variable  ${criterias}
  ${need_reg_criteria}=  Set variable  ${True}
  Set Global Variable  ${need_reg_criteria}
  
  [return]  ${TENDER}
  
Доповнити negotiation
  [Arguments]    ${username}    ${tender_data}    ${plan_uaid}
  Select From List By Value  id=slPosition_cause  ${tender_data.data.cause}
  Input text  id=ePosition_causeDescription  ${tender_data.data.causeDescription}

Доповнити esco
  [Arguments]    ${username}    ${tender_data}    ${plan_uaid}
  Select From List By Value  id=slPosition_fundingKind  ${tender_data.data.fundingKind}
  ${val}=  Evaluate  ${tender_data.data.NBUdiscountRate} * 100
  ${str}=  Convert To String  ${val}
  Input text  id=ePosition_NBUdiscountRate_100  ${str}
  
  ${val}=  Evaluate  ${tender_data.data.lots[0].minimalStepPercentage} * 100
  ${str}=  Convert To String  ${val}
  Input text  id=ePosition_minimalStepPercentage_100  ${str}
  ${val}=  Evaluate  ${tender_data.data.lots[0].yearlyPaymentsPercentageRange} * 100
  ${str}=  Convert To String  ${val}
  Input text  id=ePosition_yearlyPaymentsPercentageRange_100  ${str}

Доповнити closeFrameworkAgreementUA
  [Arguments]    ${username}    ${tender_data}    ${plan_uaid}
  Додати лот  ${tender_data.data.lots[0]}  0
  
  Input text  id=ePosition_maxAwardsCount  ${tender_data.data.maxAwardsCount}
  Input Text  id=ePosition_agreementDuration_y  ${tender_data.data.agreementDuration[1]}
  Input Text  id=ePosition_agreementDuration_m  ${tender_data.data.agreementDuration[3]}
  Input Text  id=ePosition_agreementDuration_d  ${tender_data.data.agreementDuration[5]}

Доповнити belowThreshold  
  [Arguments]    ${username}    ${tender_data}
  ${str}=  get_enquiryPeriod  ${tender_data}  StartDate
  Input text  id=dtpPosition_enquiryPeriod_startDate_Date  ${str}
  ${str}=  get_enquiryPeriod  ${tender_data}  StartTime
  Input text  id=ePosition_enquiryPeriod_startDate_Time  ${str}

  ${str}=  get_enquiryPeriod  ${tender_data}  EndDate
  Input text  id=dtpPosition_enquiryPeriod_endDate_Date  ${str}
  ${str}=  get_enquiryPeriod  ${tender_data}  EndTime
  Input text  id=ePosition_enquiryPeriod_endDate_Time  ${str}

  ${str}=  get_tenderPeriod  ${tender_data}  StartDate
  Input text  id=dtpPosition_tenderPeriod_startDate_Date  ${str}
  ${str}=  get_tenderPeriod  ${tender_data}  StartTime
  Input text  id=ePosition_tenderPeriod_startDate_Time  ${str}

Додати критерії
  [Arguments]  ${article_17_data}
  ${number_of_criterias}=  Get Length  ${article_17_data.data}
  set global variable  ${number_of_criterias}  
  :FOR  ${index}  IN RANGE  ${number_of_criterias}
  \  Встановити критерій  ${article_17_data.data[${index}]}

Додати критерії в тендер другого етапу
  [Arguments]  ${username}  ${tender_uaid}
  ${article_17_data}=  Підготувати дані по критеріям статті 17
  Додати критерії  ${article_17_data}
  
Встановити критерій
  [Arguments]  ${criteria}
  ${criteria}=  munch_dict  arg=${criteria}
  log  ${criteria}
  
  ${classification_id}=  Get from dictionary  ${criteria.classification}  id
  ${number_of_requirementGroups}=  Get Length  ${criteria.requirementGroups}

  :FOR  ${index}  IN RANGE  ${number_of_requirementGroups}
  \  Встановити групу вимог  ${classification_id}  ${criteria.requirementGroups[${index}]}
  
Встановити групу вимог
  [Arguments]  ${classification_id}  ${requirementGroup}
  ${requirementGroup}=  munch_dict  arg=${requirementGroup}
  log  ${requirementGroup}

  ${neeg_show_group_response}=  Run Keyword And Return Status  Element Should Not Be Visible  xpath=//div[@id="pn_requirement_record_${requirement_id}"]//div[@data-block="evidence"]
  Run Keyword If  ${neeg_show_group_response}  Click Element  xpath=//div[@id="pn_requirement_record_${requirement_id}"]/ancestor::div[@data-block="requirementGroups"]//button[@data-atid="btnAddResponces"]
  
  ${number_of_requirements}=  Get Length  ${requirementGroup.requirements}

  :FOR  ${index}  IN RANGE  ${number_of_requirements}
  \  Встановити вимогу  ${classification_id}  ${requirementGroup.requirements[${index}]}
  
Встановити вимогу
  [Arguments]  ${classification_id}  ${requirement}
  ${requirement}=  munch_dict  arg=${requirement}
  log  ${requirement}
  
  ${has_eligibleEvidences}=  Run Keyword And Return Status  Dictionary Should Contain Key  ${requirement}  eligibleEvidences
  Return From Keyword If  not ${has_eligibleEvidences}

  ${number_of_eligibleEvidences}=  Get Length  ${requirement.eligibleEvidences}
  ${requirement_title}=  Set variable	${requirement.title.replace("'", "_").replace("\"", "_")}
  
  :FOR  ${index}  IN RANGE  ${number_of_eligibleEvidences}
  \  Click Element  xpath=//div[@id="pn_criteria"]//span[@data-atid="classification.id" and text()="${classification_id}"]/ancestor::div[@data-block="criteria"]//span[@data-atid="title" and translate(translate(text(),"'","_"),'"',"_")="${requirement_title}"]/ancestor::div[@data-block="requirement"]//button[@data-atid="btnAdd"]
  \  input text  xpath=//div[@id="pn_criteria"]//span[@data-atid="classification.id" and text()="${classification_id}"]/ancestor::div[@data-block="criteria"]//span[@data-atid="title" and translate(translate(text(),"'","_"),'"',"_")="${requirement_title}"]/ancestor::div[@data-block="requirement"]//textarea[@data-atid="title"]  ${requirement.eligibleEvidences[${index}].title}
  \  input text  xpath=//div[@id="pn_criteria"]//span[@data-atid="classification.id" and text()="${classification_id}"]/ancestor::div[@data-block="criteria"]//span[@data-atid="title" and translate(translate(text(),"'","_"),'"',"_")="${requirement_title}"]/ancestor::div[@data-block="requirement"]//textarea[@data-atid="description"]  ${requirement.eligibleEvidences[${index}].description}
  \  Select From List By Value  xpath=//div[@id="pn_criteria"]//span[@data-atid="classification.id" and text()="${classification_id}"]/ancestor::div[@data-block="criteria"]//span[@data-atid="title" and translate(translate(text(),"'","_"),'"',"_")="${requirement_title}"]/ancestor::div[@data-block="requirement"]//select[@data-atid="type"]  ${requirement.eligibleEvidences[${index}].type}

Додати лот
  [Arguments]  ${lot}  ${index}

  Input text  id=ew_lot_${index}_title  ${lot.title}
  Input text  id=ew_lot_${index}_description  ${lot.description}

  Run Keyword If  ${has_en}  Input text  id=ew_lot_${index}_title_en  ${lot.title_en}
  ${has_description_en}=  Run Keyword And Return Status  Dictionary Should Contain Key  ${lot}  description_en
  Run Keyword If  ${has_en} and ${has_description_en}  Input text  id=ew_lot_${index}_description_en  ${lot.description_en}

  Run Keyword If  '${procurement_method_type}' == 'esco'  Встановити esco лоту  ${lot}  ${index}
  Run Keyword If  '${procurement_method_type}' != 'esco' and '${procurement_method_type}' != 'closeFrameworkAgreementUA'  Встановити ціну лоту  ${lot}  ${index}

  ${need_minimalStep_amount}=  Evaluate  ${has_auction} and '${procurement_method_type}' != 'esco' and '${procurement_method_type}' != 'closeFrameworkAgreementUA'
    
  ${str}=  Run Keyword If  ${need_minimalStep_amount}  Convert To String  ${lot.minimalStep.amount}
  Run Keyword If  ${need_minimalStep_amount}  input text  id=ew_lot_${index}_minimalStep_amount  ${str}

Встановити ціну лоту
  [Arguments]  ${lot}  ${index}
  ${str}=  Convert To String  ${lot.value.amount}
  Input text  id=ew_lot_${index}_value_amount  ${str}

  ${str}=  Run Keyword If  ${has_auction} and '${procurement_method_type}' != 'esco'  Convert To String  ${lot.minimalStep.amount}
  Run Keyword If  ${has_auction}  input text  id=ew_lot_${index}_minimalStep_amount  ${str}
  
Встановити esco лоту
  [Arguments]  ${lot}  ${index}
  ${val}=  Evaluate  ${lot.minimalStepPercentage} * 100
  ${str}=  Convert To String  ${val}
  input text  id=ew_lot_${index}_minimalStepPercentage_100  ${str}
  
  ${val}=  Evaluate  ${lot.yearlyPaymentsPercentageRange} * 100
  ${str}=  Convert To String  ${val}
  input text  id=ew_lot_${index}_yearlyPaymentsPercentageRange_100  ${str}
  
Видалити лот
  [Arguments]  ${username}  ${tender_uaid}  ${lot_id}
  Click Element  xpath=(//div[@data-block-id='${lot_id}'])//button[contains(@id, 'btn_lot_delete')]
  Click Element  id=btnPublic
  
Додати умови оплати
  [Arguments]  ${milestone}  ${index}

  Wait Until Page Contains Element  id=sl_milestone_${index}_title

  Select From List By Value  id=sl_milestone_${index}_title  ${milestone.title}
  Select From List By Value  id=sl_milestone_${index}_code  ${milestone.code}

  ${KeyIsPresent}=  Run Keyword And Return Status  Dictionary Should Contain Key  ${milestone}  description
  Run Keyword If  ${KeyIsPresent}  Input Text  id=e_milestone_${index}_description  ${milestone.description}

  ${str}=  Convert To String  ${milestone.duration.days}
  Input Text  id=e_milestone_${index}_duration_days  ${str}
  Select From List By Value  id=sl_milestone_${index}_duration_type  ${milestone.duration.type}
  ${str}=  Convert To String  ${milestone.percentage}
  Input Text  id=e_milestone_${index}_percentage  ${str}

Додати предмет тендера
  [Arguments]  ${item}   ${index}

  Input Text  id=ew_item_${index}_description  ${item.description}
  Run Keyword If  '${procurement_method_type}' in ['aboveThresholdEU', 'aboveThresholdUA.defense', 'competitiveDialogueEU', 'esco', 'closeFrameworkAgreementUA']
  ...  input text  id=ew_item_${index}_description_en  ${item.description_en}
  input text  id=ew_item_${index}_classification_id  ${item.classification.id}
  Sleep  1
  Wait Until Page Contains Element  xpath=(//ul[contains(@class, 'ui-autocomplete') and not(contains(@style,'display: none'))]//li//a)
  Click Element  xpath=(//ul[contains(@class, 'ui-autocomplete') and not(contains(@style,'display: none'))]//li//a)
  Run Keyword If  '${procurement_method_type}' != 'esco'  Додати не esco параметри предмету  ${item}  ${index} 

  ${is_esco}=  Evaluate  '${procurement_method_type}' in ['esco']
  
  ${str}=  Run Keyword If  not ${is_esco}  Convert To String  ${item.quantity}
  Run Keyword If  not ${is_esco}  Run Keywords
  ...  input text  id=ew_item_${index}_quantity  ${str}
  ...  AND  Select From List By Value  id=slw_item_${index}_unit_code  ${item.unit.code}
  ${str}=  Run Keyword If  not ${is_esco}  convert_ISO_DMY  ${item.deliveryDate.startDate}
  Run Keyword If  not ${is_esco}  Input text  id=dtpw_item_${index}_deliveryDate_startDate_Date  ${str}
  ${str}=  Run Keyword If  not ${is_esco}  convert_ISO_DMY  ${item.deliveryDate.endDate}
  Run Keyword If  not ${is_esco}  Input text  id=dtpw_item_${index}_deliveryDate_endDate_Date  ${str}

  Input text  id=ew_item_${index}_deliveryAddress_countryName  ${item.deliveryAddress.countryName}
  Input text  id=ew_item_${index}_deliveryAddress_postalCode  ${item.deliveryAddress.postalCode}
  Input text  id=ew_item_${index}_deliveryAddress_region  ${item.deliveryAddress.region}
  Input text  id=ew_item_${index}_deliveryAddress_locality  ${item.deliveryAddress.locality}
  Input text  id=ew_item_${index}_deliveryAddress_streetAddress  ${item.deliveryAddress.streetAddress}
  
  ${str}=  Convert To String  ${item.deliveryLocation.latitude}
  Input text  id=ew_item_${index}_deliveryLocation_latitude  ${str}
  ${str}=  Convert To String  ${item.deliveryLocation.longitude}
  Input text  id=ew_item_${index}_deliveryLocation_longitude  ${str}

Видалити предмет закупівлі
  [Arguments]  ${username}  ${tender_uaid}  ${item_id}  ${lot_id}=${Empty}
  uub.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  Click Element  xpath=(//div[@data-block-id='${item_id}'])//button[contains(@id, 'btn_item_delete')]
  Click Element  id=btnPublic

################################## Нецінові показники ######################################

Додати неціновий показник на тендер
  [Arguments]  ${username}  ${tender_uaid}  ${feature}
#  uub.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  Wait Until Element Contains  id=page_shown  Y  10
  Додати неціновий критерій  ${feature}
  Append To List  ${USERS.users['${username}'].tender_data.data['features']}  ${feature}
  log  ${USERS.users['${username}'].tender_data.data}
  Click Element  id=btnPublic  
  sleep  1
  Wait Until Element Contains  id=page_shown  Y  10

Додати неціновий показник на предмет
  [Arguments]  ${username}  ${tender_uaid}  ${feature}  ${item_id}
#  uub.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  Wait Until Element Contains  id=page_shown  Y  10
  Додати неціновий критерій  ${feature}
  Click Element  id=btnPublic  
  sleep  1
  Wait Until Element Contains  id=page_shown  Y  10

Додати неціновий показник на лот
  [Arguments]  ${username}  ${tender_uaid}  ${feature}  ${lot_id}
#  uub.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  Wait Until Element Contains  id=page_shown  Y  10
  Додати неціновий критерій  ${feature}
  Click Element  id=btnPublic  
  sleep  1
  Wait Until Element Contains  id=page_shown  Y  10
  
Додати неціновий критерій
  [Arguments]   ${feature}  
  log  ${feature}
  Run Keyword If  '${feature.featureOf}' == 'item'  Click Element  xpath=(//div[@data-block="item"])[last()]//button[contains(@id, 'btn_item_features_add')]
  ...  ELSE If  '${feature.featureOf}' == 'lot'  Click Element  xpath=(//div[@data-block="lot"])[last()]//button[contains(@id, 'btn_lot_features_add')]
  ...  ELSE  Click Element  id=btn_features_add

  Input text  xpath=(//div[@data-block="feature"])[last()]//*[@data-atid="title"]   ${feature.title}
  Input text  xpath=(//div[@data-block="feature"])[last()]//*[@data-atid="description"]   ${feature.description}

    ${number_of_enum}=  Get Length  ${feature.enum}
    set global variable  ${number_of_enum}
    :FOR  ${index}  IN RANGE  ${number_of_enum}
  \  Click Element  xpath=(//div[@data-block="feature"])[last()]//button[@data-atid="btn_add_feature_enum"]
    \  Додати вагу нецінового критерія  ${feature.enum[${index}]}

Додати вагу нецінового критерія
    [Arguments]   ${enum}
  ${value}=  Evaluate  ${enum.value} * 100
  ${str}=  Convert To String  ${value}
  Input text  xpath=(//div[@data-block="feature_enum"])[last()]//*[@data-atid="value"]   ${str}
  Input text  xpath=(//div[@data-block="feature_enum"])[last()]//*[@data-atid="title"]   ${enum.title}

Видалити неціновий показник
  [Arguments]  ${username}  ${tender_uaid}  ${feature_id}
#  uub.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  Wait Until Element Contains  id=page_shown  Y  10
  Click Element  xpath=//div[@data-block-id='${feature_id}']//button[@data-atid="btn_delete_feature"]
  Click Element  id=btnPublic  
  sleep  1
  Wait Until Element Contains  id=page_shown  Y  10
  
Встановити tenderPeriod endDate
  [Arguments]    ${username}    ${tender_data}
  
  ${str}=  get_tenderPeriod  ${tender_data}  EndDate
  Input text  id=dtpPosition_tenderPeriod_endDate_Date  ${str}
  ${str}=  get_tenderPeriod  ${tender_data}  EndTime
  Input text  id=ePosition_tenderPeriod_endDate_Time  ${str}

Завантажити документ
  [Arguments]  ${username}  ${filepath}  ${tender_uaid}
  uub.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  Click Element  id=btn_documents_add
  Choose File  xpath=(//form[@id='upload_form']//input[@name='file'])  ${filepath}
  Reload Page
  Wait Until Element Contains  id=page_shown  Y  10

Пошук тендера по ідентифікатору
  [Arguments]  ${username}  ${tender_uaid}  ${save_key}=tender_data
  Switch Browser  ${username}
  Reload Page
  go to  ${BROKERS['uub'].tenders_page}
  Wait Until Page Contains Element  id=btFilterNumber
  Sleep  1
  ${has_filter}=  Run Keyword And Return Status    Element Should Be Visible    xpath=//input[contains(@id, "ew_fv_"]
#  Run Keyword If  ${has_filter}  
  Click Element  id=btClearFilter
  Wait Until Page Contains Element  id=btFilterNumber
  Click Element  id=btFilterNumber
  Wait Until Page Contains Element  xpath=//input[contains(@id, "ew_fv_")]
  Input Text  xpath=//input[contains(@id, "ew_fv_")]  ${tender_uaid}
  Click Element  id=btnFilter
  Sleep  1
  Wait Until Page Contains Element  xpath=//a[contains(@id, "title")]
  Sleep  1
  Click Element  xpath=//a[contains(@id, "title")]
  Wait Until Element Contains  id=page_shown  Y  10
  
  Run Keyword If  ${first_search}  Run Keyword And Ignore Error  Перший пошук  ${username}
  
Перший пошук
  [Arguments]  ${username}
  ${first_search}=  Set variable  ${False}
  ${procurement_method_type}=  get text   id=tPosition_procurementMethodType
  set global variable  ${procurement_method_type}

  ${status}=  Get Text  id=tPosition_status
  Run Keyword If  not '${status}' in ['active.tendering', 'active.enquiries']  Return
  Run Keyword If  '${username}' == 'uub_Viewer'  Return

  ${has_initial_data}=  Run Keyword And Return Status  Dictionary Should Contain Key  ${USERS.users['${tender_owner}']}  initial_data

  ${tender_data}=  Run keyword if  ${has_initial_data}  Get From Dictionary  ${USERS.users['${tender_owner}'].initial_data}  data
  ...  ELSE  Get From Dictionary  ${USERS.users['${tender_owner}'].tender_data}  data
 
  ${tender_data}=  copy_object  ${tender_data}
  ${tender_data}=  munch_dict  arg=${tender_data}
  log  ${tender_data}
  log  ${USERS.users['${tender_owner}'].tender_data}

  Run Keyword If  '${username}' == '${tender_owner}'  Set To Dictionary  ${USERS.users['${tender_owner}'].tender_data}  data=${tender_data}
  Run Keyword If  '${username}' != 'uub_Viewer'  Set To Dictionary  ${USERS.users['${username}']}  tender_data=${USERS.users['${tender_owner}'].tender_data}
  
#  Set To Dictionary  ${USERS.users['${username}']}  tender_data=${USERS.users['${tender_owner}'].tender_data}
  
#  Run Keyword If  '${username}' == '${tender_owner}'  Run Keywords  Set To Dictionary  ${USERS.users['${tender_owner}'].tender_data}  data=${tender_data}
#  ...  Else  Set To Dictionary  ${USERS.users['${username}']}  tender_data=${USERS.users['${tender_owner}'].tender_data}

#  ${hasdata}=  Run Keyword And Return Status  Dictionary Should Contain Key  ${USERS.users['${username}']}  tender_data
#  Run Keyword If  not ${hasdata}  Set To Dictionary  ${USERS.users['${username}']}  tender_data=${USERS.users['${tender_owner}'].tender_data}
  
  log  ${USERS.users['${username}'].tender_data}
  
  Run Keyword If  ${need_reg_criteria}  Run Keywords  
  ...  Set To Dictionary  ${USERS.users['${tender_owner}'].tender_data.data}  criteria=${criterias}
  ...  AND  log  ${USERS.users['${tender_owner}'].tender_data}
  ...  AND  Set Variable  ${need_reg_criteria}  ${False}

Створити постачальника, додати документацію і підтвердити його
  [Arguments]   ${username}   ${tender_uaid}   ${supplier_data}   ${filepath}
##debug  uub.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  
  Wait Until Element Contains  id=page_shown  Y  10
  Click Element  id=btn_Award_add
  Wait Until Element Is Visible  id=value_amount
  ${str}=  Convert To String  ${supplier_data.data.value.amount}
  input text  id=value_amount  ${str}

  ${supplier}  Set variable  ${supplier_data.data.suppliers[0]}
  
  Select From List By Value  id=slw_Org_1_PE_scale  ${supplier.scale}
  input text  id=ew_Org_1_CP_name  ${supplier.contactPoint.name}
  input text  id=ew_Org_1_CP_email  ${supplier.contactPoint.email}
  input text  id=ew_Org_1_CP_telephone  ${supplier.contactPoint.telephone}
  input text  id=ew_Org_1_CP_url  ${supplier.contactPoint.url}
  input text  id=ew_Org_1_PE_identifier_id  ${supplier.identifier.id}
  input text  id=ew_Org_1_PE_name  ${supplier.name}
  input text  id=ew_Org_1_PE_identifier_legalName  ${supplier.identifier.legalName}
  input text  id=ew_Org_1_PE_address_postalCode  ${supplier.address.postalCode}
  Select From List By Value  id=slw_Org_1_PE_address_countryName  ${supplier.address.countryName}
  Select From List By Value  id=slw_Org_1_PE_address_region  ${supplier.address.region}
  input text  id=ew_Org_1_PE_address_locality  ${supplier.address.locality}
  input text  id=ew_Org_1_PE_address_streetAddress  ${supplier.address.streetAddress}

  click element    xpath=//div[@id="dgAward"]//button[@data-atid="btnSend"]
  Sleep  1
  Wait Until Element Contains  id=page_shown  Y  10
  uub.Завантажити документ рішення кваліфікаційної комісії тендеру  ${filepath}  0
  Sleep  1
  Wait Until Element Contains  id=page_shown  Y  10
  Click Element  xpath=(//div[@id="pnAwardList"]//button[contains(@id, 'bt_award_public')])[last()]
  Sleep  1
  Wait Until Element Contains  id=page_shown  Y  10

##debug  Run Keyword If  '${procurement_method_type}' == 'reporting'  Click Element  xpath=(//div[@id="pnAwardList"]//button[contains(@id, 'bt_contract_save')])[last()]
  
Оновити сторінку з тендером
  [Arguments]   ${username}    ${tender_uaid}
  Reload Page

Отримати інформацію із тендера
  [Arguments]   ${username}   ${tender_uaid}   ${fieldname}
  ${not_present_ref}=  Run Keyword And Return Status  Element Should Not Be Visible  id=position_ref
  Run Keyword if  ${not_present_ref}  Wait Until Element Contains  id=page_shown  Y  10
  
  ${isPositionForm}=  Run Keyword And Return Status  Location Should Contain  /tender/
  ${status_check}=  Evaluate  '${fieldname}' == 'status' or '${fieldname}' == 'qualificationPeriod.endDate'
  Run Keyword If  ${status_check} and not ${isPositionForm}  uub.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  
  Run Keyword If  ${status_check}  Run keywords
  ...  Дочекатись синхронізації з майданчиком  ${username}
  ...  AND  Wait Until Element Contains  id=page_shown  Y  10
  
    ${return_value}=  Run Keyword If  '${fieldname}' == 'title'  Get Text   id=tePosition_title
    ...  ELSE IF    '${fieldname}' == 'description'                                        Get Text   id=tePosition_description
    ...  ELSE IF    '${fieldname}' == 'tenderID'                                           Get Text   id=tPosition_tenderID
    ...  ELSE IF    '${fieldname}' == 'mainProcurementCategory'                            Get Text   id=tPosition_mainProcurementCategory
    ...  ELSE IF    '${fieldname}' == 'procurementMethodType'                              get text   id=tPosition_procurementMethodType
    ...  ELSE IF    '${fieldname}' == 'maxAwardsCount'                                     Отримати інформацію з елементу за шляхом //*[@id='maxAwardsCount']   id=tePosition_maxAwardsCount
    ...  ELSE IF    '${fieldname}' == 'value.valueAddedTaxIncluded'                        is_checked  cbPosition_value_valueAddedTaxIncluded
    ...  ELSE IF    '${fieldname}' == 'value.currency'                                     Get Text   id=tPosition_value_currency
    ...  ELSE IF    '${fieldname}' == 'value.amount'                                       Get Text   id=tPosition_value_amount
    ...  ELSE IF    '${fieldname}' == 'minimalStep.amount'                                 Get Text   id=tPosition_minimalStep_amount
    ...  ELSE IF    '${fieldname}' == 'status'                                             Get Text   id=tPosition_status
    ...  ELSE IF    '${fieldname}' == 'features[0].title'                                  Отримати інформацію з елементу за шляхом //*[@data-block="feature"][1]//*[@data-atid='title']
    ...  ELSE IF    '${fieldname}' == 'features[0].description'                            Отримати інформацію з елементу за шляхом //*[@data-block="feature"][1]//*[@data-atid='description']
    ...  ELSE IF    '${fieldname}' == 'enquiryPeriod.startDate'                            Get Text   id=tPosition_enquiryPeriod_startDate
    ...  ELSE IF    '${fieldname}' == 'enquiryPeriod.endDate'                              Get Text   id=tPosition_enquiryPeriod_endDate
    ...  ELSE IF    '${fieldname}' == 'tenderPeriod.startDate'                             Get Text   id=tPosition_tenderPeriod_startDate
    ...  ELSE IF    '${fieldname}' == 'tenderPeriod.endDate'                               Get Text   id=tPosition_tenderPeriod_endDate
    ...  ELSE IF    '${fieldname}' == 'qualificationPeriod.endDate'                        Get Text   id=tPosition_qualificationPeriod_endDate
    ...  ELSE IF    '${fieldname}' == 'auctionPeriod.startDate'                            Get Text   id=tPosition_auctionPeriod_startDate
    ...  ELSE IF    'lots' in '${fieldname}'  Отримати інформацію по id про ${fieldname}
    ...  ELSE IF    'items' in '${fieldname}'  Отримати інформацію по id про ${fieldname}
    ...  ELSE IF    'questions' in '${fieldname}'  Отримати інформацію по id про ${fieldname}
    ...  ELSE IF    'funders' in '${fieldname}'  Отримати інформацію по id про ${fieldname}
    ...  ELSE IF    'awards' in '${fieldname}'  Отримати інформацію по id про ${fieldname}
    ...  ELSE IF    'contracts' in '${fieldname}'  Отримати інформацію по id про ${fieldname}
    ...  ELSE IF    'milestones' in '${fieldname}'  Отримати інформацію по id про ${fieldname}
    ...  ELSE IF    'procuringEntity' in '${fieldname}'  Отримати інформацію по id про ${fieldname}
    ...  ELSE IF    '${fieldname}' == 'qualifications[0].status'                           Get Text  xpath=//div[contains(@id, 'pn_ql_Record')][1]//span[@data-atid='status']
    ...  ELSE IF    '${fieldname}' == 'qualifications[1].status'                           Get Text  xpath=//div[contains(@id, 'pn_ql_Record')][2]//span[@data-atid='status']
    ...  ELSE IF    '${fieldname}' == 'agreements[0].status'                               Get Text  xpath=//div[@data-block="agreement"]//span[@data-atid='status']
    ...  ELSE IF    '${fieldname}' == 'agreements[0].agreementID'                          Get Text  xpath=//div[@data-block="agreement"]//span[@data-atid='agreementID']
    ...  ELSE IF    '${fieldname}' == 'cause'                                              Get Text  id=tPosition_items_cause
    ...  ELSE IF    '${fieldname}' == 'causeDescription'                                   Отримати інформацію з елементу за шляхом //*[@data-atid='causeDescription']
    ...  ELSE IF    '${fieldname}' == 'agreementDuration'                                  Get Text  id=tePosition_agreementDuration
    ...  ELSE IF    '${fieldname}' == 'documents[0].title'                                 Get Text  xpath=(//div[@id='pn_trd_doc_place']//a[contains(@class, 'doc_title')])[1]
    ...  ELSE IF    '${fieldname}' == 'budget.amount'                                      Отримати інформацію про ${fieldname}
    ...  ELSE IF    '${fieldname}' == 'NBUdiscountRate'                                    Get Text  id=tPosition_NBUdiscountRate
    ...  ELSE IF    '${fieldname}' == 'complaintPeriod.endDate'                            Get Text  id=tPosition_complaintPeriod_endDate
    ...  ELSE IF    '${fieldname}' == 'minimalStepPercentage'                              Get Text  id=tPosition_minimalStepPercentage
    ...  ELSE IF    'fundingKind' in '${fieldname}'                                        Get Text  id=tPosition_fundingKind
    ...  ELSE IF    '${fieldname}' == 'yearlyPaymentsPercentageRange'                      Get Text  id=tPosition_yearlyPaymentsPercentageRange
    ...  ELSE IF    '${fieldname}' == 'enquiryPeriod.clarificationsUntil'                  Get Text  id=tPosition_clarificationsUntil

    ${return_value}=   Run Keyword If    '${fieldname}' == 'maxAwardsCount'  convert to number  ${return_value}
    ...  ELSE IF    'value.amount' in '${fieldname}'  convert to number  ${return_value.replace(" ", "").replace(',', '.')}
    ...  ELSE IF    'value.amountNet' in '${fieldname}'  convert to number  ${return_value.replace(" ", "").replace(',', '.')}
    ...  ELSE IF    'minimalStep.amount' in '${fieldname}'  convert to number  ${return_value.replace(" ", "").replace(',', '.')}
    ...  ELSE IF    '.quantity' in '${fieldname}'  convert to number  ${return_value.replace(" ", "").replace(',', '.')}
    ...  ELSE IF    'minimalStep.amount' in '${fieldname}'  convert to number  ${return_value.replace(" ", "").replace(',', '.')}
    ...  ELSE IF    'minimalStepPercentage' in '${fieldname}'  convert to number  ${return_value.replace(" ", "").replace(',', '.')}
    ...  ELSE IF    'yearlyPaymentsPercentageRange' in '${fieldname}'  convert to number  ${return_value.replace(" ", "").replace(',', '.')}
    ...  ELSE IF    '${fieldname}' == 'minimalStep.amount'  convert to number  ${return_value.replace(" ", "").replace(',', '.').replace(u'грн', '')}
    ...  ELSE IF    '${fieldname}' == 'NBUdiscountRate'  convert to number  ${return_value}
    ...  ELSE IF    'duration.days' in '${fieldname}'  convert to integer  ${return_value}
    ...  ELSE IF    'percentage' in '${fieldname}'  convert to integer  ${return_value}
    ...  ELSE  Set Variable  ${return_value}

  ${valueAddedTaxIncluded}=  Run Keyword If  '${fieldname}' == 'value.amount'  is_checked  cbPosition_value_valueAddedTaxIncluded
  ...  ELSE  Set Variable  ${return_value}

  Run Keyword If  '${fieldname}' == 'value.amount'  Run Keywords  
  ...  Set_To_Object  ${USERS.users['${tender_owner}'].tender_data.data}  value.valueAddedTaxIncluded  ${valueAddedTaxIncluded}
  ...  AND  Set_To_Object  ${USERS.users['${tender_owner}'].tender_data.data}  procurementMethodType  ${procurement_method_type}
  ...  AND  Set To Dictionary  ${USERS.users['${tender_owner}'].tender_data}  data=${USERS.users['${tender_owner}'].tender_data.data}
  ...  AND  log  ${USERS.users['${tender_owner}'].tender_data}

    [Return]  ${return_value}

Отримати інформацію по id про questions[${index}].${fieldname}
  ${present}=  Run Keyword And Return Status  Element Should Not Be Visible  id=position_ref
  Run Keyword If  ${present}  Перейти до сторінки запитань
  ${index}=  inc  ${index}
  ${return_value}=  Get text  xpath=(//div[@data-block="question"])[${index}]//*[@data-atid="${fieldname}" and not(contains(@style,'display: none'))]
  [return]  ${return_value}

Отримати інформацію по id про awards[${index}].${fieldname}
  ${index}=  inc  ${index}
  
  Run Keyword If  'supplier' in '${fieldname}'  Click Element  xpath=//div[@data-block="award"][${index}]//a[@data-atid="supplier"]
  sleep  1
  
  ${return_value}=  Run Keyword If  'supplier' in '${fieldname}'  Отримати інформацію по id про ${fieldname}
  ...  ELSE IF  '${fieldname}' == 'documents[0].title'  Get Text  xpath=(//div[@data-block="award"])[${index}]//div[contains(@id, 'pn_doc_award_')]//a[contains(@class, 'doc_title')]
  ...  ELSE IF  'value.amount' in '${fieldname}'  Get Text   xpath=(//div[@data-block="award"])[${index}]//*[@data-atid="${fieldname}"]
  ...  ELSE IF  'currency' in '${fieldname}'  Get Text   id=tPosition_value_currency
  ...  ELSE IF  'valueAddedTaxIncluded' in '${fieldname}'  is_checked  cbPosition_value_valueAddedTaxIncluded
  ...  ELSE  Get text  xpath=(//div[@data-block="award"])[${index}]//*[@data-atid="${fieldname}" and not(contains(@style,'display: none'))]

  Run Keyword If  'supplier' in '${fieldname}'  Click Element  xpath=//div[@id="dgAward"]//button[contains(@class, 'close')]

  [return]  ${return_value}

Отримати інформацію по id про suppliers[${index}].${fieldname}
  ${return_value}=  Get text  xpath=//div[@id="dgAward"]//*[@data-atid="${fieldname}" and not(contains(@style,'display: none'))]
  [return]  ${return_value}

Отримати інформацію по id про funders[${index}].${fieldname}
  ${index}=  inc  ${index}
  ${return_value}=  Get text  xpath=(//div[@data-block="funder"])[${index}]//*[@data-atid="${fieldname}"] 
  [return]  ${return_value}

Отримати інформацію по id про procuringEntity.${fieldname}
  ${return_value}=  Get text  xpath=//div[@data-block="procuringEntity"]//*[@data-atid="${fieldname}" and not(contains(@style,'display: none'))]
  [return]  ${return_value}

Отримати інформацію по id про lots[${index}].${fieldname}
  ${index}=  inc  ${index}
    ${return_value}=  Run Keyword If  'currency' in '${fieldname}'  Get Text   id=tPosition_value_currency
  ...  ELSE IF  'valueAddedTaxIncluded' in '${fieldname}'  is_checked  cbPosition_value_valueAddedTaxIncluded
  ...  ELSE IF  'fundingKind' in '${fieldname}'  Get Text  id=tPosition_fundingKind
  ...  ELSE   Get text  xpath=(//div[@data-block="lot"])[${index}]//*[@data-atid="${fieldname}" and not(contains(@style,'display: none'))]
  [return]  ${return_value}

Отримати інформацію по id про items[${index}].${fieldname}
  ${index}=  inc  ${index}
  ${return_value}=  Get text  xpath=(//div[@data-block="item"])[${index}]//*[@data-atid="${fieldname}" and not(contains(@style,'display: none'))]
  [return]  ${return_value}

Отримати інформацію по id про contracts[${index}].${fieldname}
  Run Keyword If  '${procurement_method_type}' in ['negotiation', 'negotiation_quick']  Очікування закінчення оскарження договору

  ${index}=  inc  ${index}
  ${return_value}=  Отримати інформацію з елементу сторінки за шляхом (//div[@data-block="contract"])[${index}]//*[@data-atid="${fieldname}"]
  [return]  ${return_value}

Отримати інформацію по id про milestones[${index}].${fieldname}
  ${index}=  inc  ${index}
  ${return_value}=  Get text  xpath=(//div[@data-block="milestone"])[${index}]//*[@data-atid="${fieldname}" and not(contains(@style,'display: none'))]
  [return]  ${return_value}

Отримати contracts.status
    ${return_value}=    Get Text   xpath=(//td[contains(@class, 'qa_status_award')])[1]
    [Return]  ${return_value}

Видалити донора
  [Arguments]  ${username}  ${tender_uaid}  ${funders_index}
  Wait Until Element Contains  id=page_shown  Y  10
  click element  id=lcb_funder_has
  Click Element  id=btnPublic
  Wait Until Element Contains  id=page_shown  Y  10

Додати донора
  [Arguments]  ${username}  ${tender_uaid}  ${funders_data}
  Wait Until Element Contains  id=page_shown  Y  10
  log  ${USERS.users['${username}'].tender_data}
  click element  id=lcb_funder_has
  Sleep  1
  Select From List By Value  id=sl_funder_list  ${funders_data.identifier.id}
  click element  id=bt_funder
  Click Element  id=btnPublic
  Wait Until Element Contains  id=page_shown  Y  10

Отримати тест із поля і показати на сторінці
  [Arguments]  ${fieldname}
  ${return_value}=  Get Text  ${locator.${fieldname}}
  [return]  ${return_value}

Внести зміни в тендер
  [Arguments]  ${username}   ${tender_uaid}   ${fieldname}   ${fieldvalue}
  ${present}=  Run Keyword And Return Status  Element Should Not Be Visible  id=page_shown
  Run Keyword if  ${present}  uub.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}

  ${str}=  Run Keyword If  '${fieldname}' == 'tenderPeriod.endDate'  convert_ISO_DMY  ${fieldvalue}
  ...  ELSE IF  '${fieldname}' == 'maxAwardsCount'  Convert To String  ${fieldvalue}
  ...  ELSE  Set Variable  ${fieldvalue}

  ${str_HM}=  Run Keyword If  '${fieldname}' == 'tenderPeriod.endDate'  convert_ISO_HM  ${fieldvalue}
  ...  ELSE  Set Variable  ${fieldvalue}

  Run Keyword If  '${fieldname}' == 'tenderPeriod.endDate'  input text  id=dtpPosition_tenderPeriod_endDate_Date  ${str}
  Run Keyword If  '${fieldname}' == 'tenderPeriod.endDate'  input text  id=ePosition_tenderPeriod_endDate_Time  ${str_HM}
  Run Keyword If  '${fieldname}' == 'tenderPeriod.endDate'  Set To Dictionary  ${USERS.users['${tender_owner}'].initial_data.data.tenderPeriod}  endDate=${fieldvalue}  
  Run Keyword If  '${fieldname}' == 'maxAwardsCount'  input text  id=ePosition_maxAwardsCount  ${str}
  Run Keyword If  '${fieldname}' == 'description'  input text  id=ePosition_description  ${str}
  Run Keyword If  '${fieldname}' == 'title'  input text  id=ePosition_title  ${str}
  
  log  ${USERS.users['${tender_owner}'].initial_data}
  Click Element  id=btnPublic
  Wait Until Element Contains  id=page_shown  Y  30
  Run Keyword If  '${fieldname}' == 'tenderPeriod.endDate'  sleep  30
  
Змінити лот
    [Arguments]  ${username}   ${tender_uaid}   ${lot_id}   ${fieldname}    ${fieldvalue}

  ${str}=  Run Keyword If  '${fieldname}' == 'value.amount' or '${fieldname}' == 'minimalStep.amount'  Convert To String  ${fieldvalue}
  ...  ELSE  Set Variable  ${fieldvalue}

  Run Keyword If  '${fieldname}' == 'value.amount' and '${procurement_method_type}' == 'closeFrameworkAgreementUA'  input text  id=ePosition_value_amount  ${str}
  Run Keyword If  '${fieldname}' == 'value.amount' and '${procurement_method_type}' == 'closeFrameworkAgreementUA'  input text  id=ePosition_minimalStep_percent  ${1}
  Run Keyword If  '${fieldname}' == 'minimalStep.amount' and '${procurement_method_type}' == 'closeFrameworkAgreementUA'  input text  id=ePosition_minimalStep_percent  ${str}
  Run Keyword If  '${fieldname}' == 'value.amount' and '${procurement_method_type}' != 'closeFrameworkAgreementUA'  input text  xpath=(//div[@data-block-id='${lot_id}'])//input[contains(@id, 'value_amount')]  ${str}
  Run Keyword If  '${fieldname}' == 'value.amount' and '${procurement_method_type}' != 'closeFrameworkAgreementUA'  input text  xpath=(//div[@data-block-id='${lot_id}'])//input[contains(@id, 'minimalStep_percent')]  ${1}
  Run Keyword If  '${fieldname}' == 'minimalStep.amount' and '${procurement_method_type}' != 'closeFrameworkAgreementUA'  input text  xpath=(//div[@data-block-id='${lot_id}'])//input[contains(@id, 'minimalStep_amount')]  ${str}
  Run Keyword If  '${fieldname}' == 'title'  input text  xpath=(//div[@data-block-id='${lot_id}'])//textarea[contains(@id, 'title')]  ${str}
  Run Keyword If  '${fieldname}' == 'description'  input text  xpath=(//div[@data-block-id='${lot_id}'])//textarea[contains(@id, 'description')]  ${str}

  Click Element  id=btnPublic
  Wait Until Element Contains  id=page_shown  Y  30

Отримати інформацію про tenderPeriod.startDate
  ${date_value}=  Get Text  tdtpPosition_tenderPeriod_startDate_Date
  ${time_value}=  Get Text  tePosition_tenderPeriod_startDate_Time
  ${return_value}=  convert_uub_date_to_iso  ${date_value}  ${time_value}
  [return]  ${return_value}

################################## Пропозиція ################################

Подати цінову пропозицію
  [Arguments]  ${username}  ${tender_uaid}  ${bid}  ${lots_ids}=None  ${features_ids}=None
  uub.Подати цінову пропозицію в статусі draft  ${username}  ${bid}  ${lots_ids}  ${features_ids}
  Wait Until Element Is Visible  xpath=(//*[@id='btn_public'])
  Click Element  id=btn_public
  ${bid_draft_view}=  Set variable  ${False}
  Set Global Variable  ${bid_draft_view}

  Wait Until Element Is Not Visible  id=waiting_published
  Sleep  1
  Wait Until Element Is Visible  xpath=(//*[@id='bid_load_status']) 
  
Подати цінову пропозицію в статусі draft
  [Arguments]  ${username}  ${tender_uaid}  ${bid}  ${lots_ids}=None  ${features_ids}=None
  uub.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  Click Element  id=btnBid
  Wait Until Element Is Visible  xpath=(//*[@id='bid_load_status']) 
  
  ${bid_draft_view}=  Set variable  ${True}
  Set Global Variable  ${bid_draft_view}
  
  ${islot}=  Run Keyword And Return Status  Dictionary Should Contain Key  ${USERS.users['${tender_owner}'].initial_data.data}  lots
  Set Global Variable  ${islot}
  ${lot_value}=  Run Keyword If  ${islot}  Get From Dictionary  ${bid.data}  lotValues

  ${hasFeatures}=  Run Keyword And Return Status  Dictionary Should Contain Key  ${USERS.users['${tender_owner}'].initial_data.data}  features
  ${parameters}=  Run Keyword If  ${hasFeatures}  Get From Dictionary  ${bid.data}  parameters

  Run Keyword If  '${procurement_method_type}' != 'belowThreshold'  Click Element  id=lcbBid_selfQualified
  Run Keyword If  '${procurement_method_type}' == 'aboveThresholdUA.defense'  Click Element  id=lcbBid_selfEligible

  Run Keyword If    '${procurement_method_type}' == 'esco'  Додати пропозицію лоту esco  ${bid}  ${lots_ids}
  ...  ELSE IF  not ${islot}  Додати ставку  ${bid}
  ...  ELSE  Додати пропозицію лоту загально  ${bid}  ${lots_ids}

  ${hasFeatures}=  Run Keyword And Return Status  Dictionary Should Contain Key  ${tender_data.data}  features

  Click Element  id=btn_save
  Sleep  1
  Wait Until Element Is Visible  xpath=(//*[@id='bid_load_status']) 

Завантажити відповіді на критерії закупівлі  
  [Arguments]  ${username}  ${tender_uaid}  ${bid_criteria}
  log  ${bid_criteria}
  ${number_of_requirement_responses}=  Get Length  ${bid_criteria.data}
  set global variable  ${number_of_requirement_responses}  
  :FOR  ${index}  IN RANGE  ${number_of_requirement_responses}
  \  Надати відповідь на критерій  ${bid_criteria.data[${index}]}
  
Надати відповідь на критерій  
  [Arguments]  ${requirement_response}
  ${requirement_response}=  munch_dict  arg=${requirement_response}
  log  ${requirement_response}
  
  ${requirement_id}=  Get from dictionary  ${requirement_response.requirement}  id
  
  ${neeg_show_group_response}=  Run Keyword And Return Status  Element Should Not Be Visible  xpath=//div[@id="pn_requirement_record_${requirement_id}"]//div[@data-block="evidence"]
  Run Keyword If  ${neeg_show_group_response}  Click Element  xpath=//div[@id="pn_requirement_record_${requirement_id}"]/ancestor::div[@data-block="requirementGroups"]//button[@data-atid="btnAddResponces"]
  
  ${evidences}=  Get from dictionary  ${requirement_response}  evidences
  ${number_of_evidences}=  Get Length  ${evidences}

  :FOR  ${index}  IN RANGE  ${number_of_evidences}
  \  input text  xpath=//div[@id="pn_requirement_record_${requirement_id}"]//div[@data-block="evidence"]//textarea[@data-atid="title"]  ${evidences[${index}].title}
  \  Run Keyword If  "${evidences[${index}].type}" == "document"  Select From List By Value  xpath=//div[@id="pn_requirement_record_${requirement_id}"]//div[@data-block="pn_relatedDocument"]//select[@data-atid="relatedDocument.id"]  ${requirement_response.evidences[${index}].relatedDocument.id}

Додати пропозицію лоту competitiveDialogue
  [Arguments]   ${bid}
  
Додати пропозицію лоту загально
    [Arguments]   ${bid}   ${lots_ids}
    ${lots}=   Get From Dictionary  ${bid.data}    lotValues
    ${number_of_lot}=  Get Length  ${lots}
    set global variable    ${number_of_lot}
    :FOR  ${index}  IN RANGE  ${number_of_lot}
    \  Додати lot ставку  ${lots[${index}]}    ${lots_ids[0]}

Додати пропозицію лоту esco
    [Arguments]   ${bid}    ${lots_ids}
    ${lots}=   Get From Dictionary  ${bid.data}    lotValues
    ${number_of_lot}=  Get Length  ${lots}
    set global variable    ${number_of_lot}
    :FOR  ${index}  IN RANGE  ${number_of_lot}
    \  Додаты lot в ставку esco    ${lots[${index}]}    ${lots_ids[0]}

Додаты lot в ставку esco
    [Arguments]  ${lots}  ${lots_ids}
	${relatedLot}=  Set variable  ${lots.relatedLot}

    ${val}=  Evaluate  ${lots.value.yearlyPaymentsPercentage} * 100
    ${str}=  convert to string   ${val}
    input text  id=eBid_yearlyPaymentsPercentage_100${relatedLot}  ${str}
    ${str}=  convert to string   ${lots.value.contractDuration.years}
    input text  id=eBid_contractDuration_years${relatedLot}  ${str}
    ${str}=  convert to string   ${lots.value.contractDuration.days}
    input text  id=eBid_contractDuration_days${relatedLot}  ${str}

    ${annual}=   Get From Dictionary       ${lots.value}    annualCostsReduction
    ${number_of_annual}=  Get Length       ${annual}
    set global variable    ${number_of_annual}
    :FOR  ${index}  IN RANGE  ${number_of_annual}
    \  ${str}=  convert to string  ${annual[${index}]}
    \  input text  id=acr_${index}_${relatedLot}  ${str}
  
Додати ставку 
  [Arguments]   ${bid}
  Wait Until Element Is Visible  xpath=(//*[@id='bid_load_status']) 
  ${str}=  Convert To String  ${bid.data.value.amount}
  Input Text  xpath=//input[@data-atid="value.amount"]  ${str}

Додати lot ставку 
  [Arguments]   ${lotValue}  ${lot_id}

  ${str}=  Convert To String  ${lotValue.value.amount}
  Run Keyword If   not '${procurement_method_type}' in ['competitiveDialogueUA', 'competitiveDialogueEU']
  ...  Input Text  xpath=//input[@data-atid="value.amount"]  ${str}

Скасувати цінову пропозицію
  [Arguments]  ${username}   ${tender_uaid}
  uub.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  Click Element  id=btnShowBid
  Wait Until Element Is Visible  xpath=(//*[@id='bid_load_status']) 
  Click Element  id=btn_delete

Змінити цінову пропозицію
  [Arguments]  ${username}  ${tender_uaid}  ${fieldname}   ${value}
##  uub.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
##  Click Element  id=btnShowBid
##  Wait Until Element Is Visible  xpath=(//*[@id='bid_load_status']) 

  ${str}=  Convert To String  ${value}
  Run Keyword if  "${fieldname}" == "value.amount"  Input Text  xpath=//input[@data-atid="value.amount"]  ${str}
  Run Keyword if  "${fieldname}" == "lotValues[0].value.amount"  Input Text  xpath=//input[@data-atid="value.amount"]  ${str}

  Click Element  id=btn_public
  Wait Until Element Is Not Visible  id=waiting_published
  Sleep  1
  Wait Until Element Is Visible  xpath=(//*[@id='bid_load_status']) 

Завантажити документ в ставку
  [Arguments]  ${username}  ${filepath}  ${tender_uaid}  ${doc_name}=documents  ${doc_type}=${None}
  run keyword if  not ${bid_draft_view}  Run keywords
  ...  uub.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ...  AND  Click Element  id=btnShowBid
  ...  AND  Wait Until Element Is Visible  xpath=(//*[@id='bid_load_status']) 
  
  Click Element  id=btn_documents_add
  
#  ${doc_type}=  Run Keyword If  '${doc_type}' == 'None'  Set variable  commercialProposal
  ${doc_type}=  Run Keyword If  '${doc_type}' == 'None'  Set variable  eligibilityDocuments
  ...  ELSE  Set variable  ${doc_type}
  Select From List By Value  id=slFileType  ${doc_type}
  Choose File  xpath=(//form[@id='upload_form']//input[@name='file'])  ${filepath}
  Wait Until Page Contains  завантажено  10
  ${doc_id}=  get text  //div[@id="diagFileUpload"]//span[@data-atid="id"]
  ${doc_title}=  get text  //div[@id="diagFileUpload"]//span[@data-atid="title"]
  
  ${data}=  Create Dictionary  title=${doc_title}  id=${doc_id}
  ${data}=  Create Dictionary  data=${data}
  Set to Dictionary  ${USERS.users['${username}']}  documents=${data}
  Click Element  //div[@id="diagFileUpload"]//button[@data-atid="btClose"]

Змінити документацію в ставці
  [Arguments]  ${username}  ${tender_uaid}  ${doc_data}  ${doc_id}
#  uub.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
#  Click Element  id=btnShowBid
  Reload Page
  Wait Until Element Is Visible  xpath=//div[@data-block-id="${doc_id}"]//button[starts-with(@id, 'bt_doc_update')]
  Click Element  xpath=//div[@data-block-id="${doc_id}"]//button[starts-with(@id, 'bt_doc_update')]
  Select From List By Value  id=slFile_confidentiality  buyerOnly
  Input text  id=eFile_confidentialityRationale  ${doc_data.data.confidentialityRationale}  
  ${file_path}  ${file_name}  ${file_content}=  create_fake_doc
  Choose File  xpath=//form[@id='upload_form']//input[@name='file']  ${filepath}
  Click Element  //div[@id="diagFileUpload"]//button[@data-atid="btClose"]
  Remove File  ${file_path}

Змінити документ в ставці
  [Arguments]  ${username}  ${tender_uaid}  ${filepath}  ${doc_id}
#  uub.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
#  Click Element  id=btnShowBid
  Reload Page
  Wait Until Element Is Visible  xpath=//div[@data-block-id="${doc_id}"]//button[starts-with(@id, 'bt_doc_update')]
  Click Element  xpath=//div[@data-block-id="${doc_id}"]//button[starts-with(@id, 'bt_doc_update')]
  Choose File  xpath=//form[@id='upload_form']//input[@name='file']  ${filepath}
  Click Element  //div[@id="diagFileUpload"]//button[@data-atid="btClose"]

Отримати інформацію із пропозиції
  [Arguments]   ${username}   ${tender_uaid}   ${fieldname}
  ${isBidForm}=  Run Keyword And Return Status  Location Should Contain  /BidForm
  Run Keyword If  not ${isBidForm}  Run keywords
  ...  uub.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ...  AND  Click Element  id=btnShowBid
  ...  AND  Wait Until Element Is Visible  xpath=(//*[@id='bid_load_status'])
  
  ${return_value}=  Run Keyword If  'value.amount' in '${fieldname}'  Отримати інформацію з елементу за шляхом //input[@data-atid="value.amount"]
  ...  ELSE IF  '${fieldname}' == 'status'  Get Text  id=tBid_status

  ${return_value}=  Run Keyword If  'value.amount' in '${fieldname}'  convert to number  ${return_value.replace(" ", "").replace(',', '.')}
  ...  ELSE  Set Variable  ${return_value}
  [Return]    ${return_value}
  
Отримати інформацію про bids
  [Arguments]  @{ARGUMENTS}
  Reload Page
  Wait Until Element Contains  id=page_shown  Y  10
  Click Element  id=bids_ref

Отримати посилання на аукціон для глядача
  [Arguments]  ${username}  ${tender_uaid}   ${lot_id}=${None}
  Reload Page
  Wait Until Element Contains  id=page_shown  Y  10
  ${result} =  Run Keyword If  ${lot_id} == ${None}  Get Text  id=aPosition_auctionUrl
  ...  ELSE   Get text  xpath=//div[@data-block="lot"])//*[@data-atid="auctionUrl" and not(contains(@style,'display: none'))]
  [return]  ${result}

Отримати посилання на аукціон для учасника
  [Arguments]    ${username}  ${tender_uaid}   ${lot_id}=${None}
  Reload Page
  Wait Until Element Contains  id=page_shown  Y  10
  ${result} =  Run Keyword If  ${lot_id} == ${None}  Get Text  id=aPosition_auctionUrl
  ...  ELSE   Get text  xpath=//div[@data-block="lot"])//*[@data-atid="auctionUrl" and not(contains(@style,'display: none'))]
  [return]  ${result}

################################## Питання ######################################

Перейти до сторінки запитань
  Wait Until Page Contains Element  id=questions_ref 
  Click Element  id=questions_ref
  Sleep  1

Задати запитання на тендер
  [Arguments]  ${username}   ${tender_uaid}   ${question}
  Wait Until Page Contains Element  id=btn_question 
  Click Element  id=btn_question
  Wait Until Element Is Visible  id=btn_SendQuestion 
  Input text  id=e_title  ${question.data.title}
  Input text  id=e_description  ${question.data.description}
  Click Element  id=btn_SendQuestion

Задати запитання на лот
  [Arguments]  ${username}   ${tender_uaid}   ${lot_id}  ${question}
  Click Element  xpath=(//div[@data-block-id='${lot_id}']//button[contains(@id, 'btn_lot_add_question')])
  Wait Until Element Is Visible  id=btn_SendQuestion 
  Input text  id=e_title  ${question.data.title}
  Input text  id=e_description  ${question.data.description}
  Click Element  id=btn_SendQuestion

Відповісти на запитання
  [Arguments]   ${username}   ${tender_uaid}  ${answer_data}  ${question_id}
  ${present}=  Run Keyword And Return Status  Element Should Not Be Visible  id=position_ref
  Run Keyword if  ${present}  Перейти до сторінки запитань
  Wait Until Page Contains Element  xpath=(//button[contains(@class, 'btAnswer') and contains(@class, '${question_id}')])
  Click Element  xpath=(//button[contains(@class, 'btAnswer') and contains(@class, '${question_id}')])
  log  ${answer_data.data.answer}
  sleep  1
  Input Text  id=e_answer  ${answer_data.data.answer}
  sleep  1
  Click Element  id=btn_SendAnswer
  
Отримати інформацію із запитання
  [Arguments]  ${username}  ${tender_uaid}  ${question_id}  ${fieldname}
  uub.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  Перейти до сторінки запитань
  ${return_value}=  Get Text  xpath=(//div[@id='pn_Record_${question_id}']//*[@data-atid="${fieldname}" 
  
  Click Element  id=position_ref
  [return]  ${return_value}

################################## Скарги  ######################################

Перейти до сторінки скарг
  Wait Until Page Contains Element  id=complaints_ref 
  Click Element  id=complaints_ref
  Sleep  1
  Wait Until Element Contains  id=page_shown  Y  10
  
Створити чернетку скарги
  [Arguments]  ${username}  ${tender_uaid}  ${complaint_data}
  Wait Until Element Contains  id=page_shown  Y  10

  Wait Until Element Is Visible  xpath=//button[contains(@id, 'btSave_')]
  Input text  xpath=//div[@id="pnList"]//div[@data-block="complaint"][last()]//textarea[contains(@id, '_title')]  ${complaint_data.data.title}
  Input text  xpath=//div[@id="pnList"]//div[@data-block="complaint"][last()]//textarea[contains(@id, '_description')]  ${complaint_data.data.description}
  Click Element  xpath=//div[@id="pnList"]//div[@data-block="complaint"][last()]//button[contains(@id, 'btSave_')]
  sleep  1
  Wait Until Element Contains  id=page_shown  Y  10

  Wait Until Element Is Visible  xpath=//div[@id="pnList"]//div[@data-block="complaint"][last()]//button[contains(@id, "btn_documents_add")]

  Click Element  xpath=//div[@id="pnList"]//div[@data-block="complaint"][last()]//button[contains(@id, "btn_documents_add")][last()]
  ${file_path}  ${file_name}  ${file_content}=  create_fake_doc
  Choose File  xpath=//form[@id='upload_form']//input[@name='file']  ${filepath}
  Click Element  //div[@id="diagFileUpload"]//button[@data-atid="btClose"]
  Remove File  ${file_path}
  sleep  1

  Wait Until Element Is Visible  xpath=//div[@id="pnList"]//div[@data-block="complaint"][last()]//button[contains(@id, 'bt_cml_send_')]
  Click Element  xpath=//div[@id="pnList"]//div[@data-block="complaint"][last()]//button[contains(@id, 'bt_cml_send_')]
  sleep  5
  Wait Until Element Contains  id=page_shown  Y  10

  ${complaint}=  Get text  xpath=//div[@id="pnList"]//div[@data-block="complaint"][last()]//*[@data-atid="content"]
  ${complaint}=  json_load  ${complaint}
  ${complaint}=  munch_dict  arg=${complaint}
  Set To Dictionary  ${USERS.users['${username}']}  complaint_access_token=123
	
  [return]  ${complaint}

Створити чернетку скарги про виправлення умов закупівлі
  [Arguments]  ${username}  ${tender_uaid}  ${complaint_data}
  Wait Until Page Contains Element  id=btn_complaint 
  Click Element  id=btn_complaint
  ${complaint}=  Створити чернетку скарги  ${username}  ${tender_uaid}  ${complaint_data}
  [return]  ${complaint}

Створити чернетку скарги про виправлення умов лоту
  [Arguments]  ${username}  ${tender_uaid}  ${complaint_data}  ${lot_id}
  Wait Until Page Contains Element  xpath=(//div[@data-block-id='${lot_id}']//button[contains(@id, 'btn_lot_add_complaint')]) 
  Click Element  xpath=(//div[@data-block-id='${lot_id}']//button[contains(@id, 'btn_lot_add_complaint')])
  ${complaint}=  Створити чернетку скарги  ${username}  ${tender_uaid}  ${complaint_data}
  [return]  ${complaint}

Створити чернетку вимоги/скарги про виправлення визначення переможця
  [Arguments]  ${username}  ${tender_uaid}  ${complaint_data}  ${index}
  ${index}=  inc  ${index}
  uub.Пошук тендера по ідентифікатору    ${username}  ${tender_uaid}
  Wait Until Page Contains Element  xpath=//div[@data-block="award"][${index}]//button[contains(@id, 'bt_award_add_complaint')]
  Click Element  xpath=//div[@data-block="award"][${index}]//button[contains(@id, 'bt_award_add_complaint')]

  ${complaint}=  Створити чернетку скарги  ${username}  ${tender_uaid}  ${complaint_data}
  [return]  ${complaint}

Створити чернетку вимоги/скарги про виправлення кваліфікації учасника
  [Arguments]  ${username}  ${tender_uaid}  ${complaint_data}  ${index}
  ${index}=  inc  ${index}
  uub.Пошук тендера по ідентифікатору    ${username}  ${tender_uaid}
  Wait Until Page Contains Element  xpath=//div[@data-block="ql"][${index}]//button[contains(@id, 'bt_ql_add_complaint')]
  Click Element  xpath=//div[@data-block="ql"][${index}][${index}]//button[contains(@id, 'bt_ql_add_complaint')]

  ${complaint}=  Створити чернетку скарги  ${username}  ${tender_uaid}  ${complaint_data}
  [return]  ${complaint}

Створити чернетку вимоги/скарги на скасування
  [Arguments]  ${username}  ${tender_uaid}  ${complaint_data}  ${index}
  ${index}=  inc  ${index}
  uub.Пошук тендера по ідентифікатору    ${username}  ${tender_uaid}
  Перейти до сторінки скаувань

  Wait Until Page Contains Element  xpath=//div[@data-block="cancellation"][${index}]//button[contains(@id, 'btComplaint_')]
  Click Element  xpath=//div[@data-block="cancellation"][${index}][${index}]//button[contains(@id, 'btComplaint_')]
  ${complaint}=  Створити чернетку скарги  ${username}  ${tender_uaid}  ${complaint_data}
  [return]  ${complaint}

Завантажити документацію до вимоги
  [Arguments]  ${username}  ${tender_uaid}  ${complaintID}  ${document}
  Click Element  xpath=//div[@data-block-id='${complaintID}']//button[contains(@id, "btn_documents_add")]
  Choose File  xpath=//form[@id='upload_form']//input[@name='file']  ${document}
  Click Element  //div[@id="diagFileUpload"]//button[@data-atid="btClose"]

Завантажити документ до скарги в окремий об'єкт
  [Arguments]  ${username}  ${tender_uaid}  ${complaintID}  ${object_index}  ${document}  ${object}=None
  uub.Завантажити документацію до вимоги  ${username}  ${tender_uaid}  ${complaintID}  ${document}

Виконати оплату скарги
  [Arguments]  ${username}  ${payment_data}
  
#  Click Element    xpath=//div[@id="pnList"]//div[@data-block="complaint"][last()]//button[contains(@id, 'bt_payment_')]
#  Click Element    xpath=//div[@id="pnList"]//div[@data-block="complaint"][last()]//button[contains(@id, 'bt_payment_LiqPay_')]
#  Wait Until Page Contains Element  xpath=//div[@id="pnList"]//div[@data-block="complaint"][last()]//a[contains(@id, 'a_LiqPayUrl_')]
  Wait Until Element Is Visible  xpath=//div[@id="pnList"]//div[@data-block="complaint"][last()]//button[contains(@id, 'bt_Сomplaint_send_pending_')]
  Click Element  xpath=//div[@id="pnList"]//div[@data-block="complaint"][last()]//button[contains(@id, 'bt_Сomplaint_send_pending_')]

Отримати інформацію із скарги
  [Arguments]   ${username}   ${tender_uaid}   ${complaintID}    ${field_name}  ${object_index}=None   ${object}=None
  uub.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  Перейти до сторінки скарг
  ${return_value}=  Get Text  xpath=//div[@data-block-id='${complaintID}']//*[@data-atid="${fieldname}" and not(contains(@style,'display: none'))]
  
  Click Element  id=position_ref
  [return]  ${return_value}

Отримати інформацію із документа до скарги
  [Arguments]  ${username}  ${tender_uaid}  ${complaintID}  ${doc_id}  ${field}
  sleep  10
  ${isPositionForm}=  Run Keyword And Return Status  Location Should Contain  /tender/
  Run Keyword If  ${isPositionForm}  Перейти до сторінки скарг

  ${return_value}=  uub.Отримати інформацію із документа  ${username}  ${tender_uaid}  ${doc_id}  ${field}
  [Return]  ${return_value}

Отримати документ до скарги  
  [Arguments]  ${username}  ${complaintID}  ${doc_id}
  ${file_name}=   uub.Отримати документ  ${tender_uaid}  ${doc_id}
  [Return]  ${file_name}

Змінити статус скарги
  [Arguments]  ${username}  ${tender_uaid}  ${complaintID}  ${confirmation_data}
  uub.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  Перейти до сторінки скарг
  sleep  3
  Run Keyword If  '${confirmation_data.data.status}' == 'mistaken'  
  ...  Click Element  xpath=//div[@data-block-id='${complaintID}']//button[contains(@id, 'bt_cml_cancel_')]

  Run Keyword If  '${confirmation_data.data.status}' == 'resolved'  Run keywords
  ...  Click Element  xpath=//div[@data-block-id='${complaintID}']//button[contains(@id, 'btComplaintAnswer_')]
  ...  AND  Input text  id=e_complaint_tendererAction  ${confirmation_data.data.tendererAction}
  ...  AND  Click Element  id=button-send-complaint-answer
  sleep  1
  Wait Until Element Contains  id=page_shown  Y  10

Змінити статус скарги на визначення пре-кваліфікації учасника
  [Arguments]  ${username}  ${tender_uaid}  ${complaintID}  ${qualification_index}  ${confirmation_data}
  Змінити статус скарги  ${username}  ${tender_uaid}  ${complaintID}  ${confirmation_data}
  
Змінити статус скарги на визначення переможця
  [Arguments]  ${username}  ${tender_uaid}  ${complaintID}  ${award_index}  ${confirmation_data}
  Змінити статус скарги  ${username}  ${tender_uaid}  ${complaintID}  ${confirmation_data}
  
################################## Пре-кваліфікація ################################

Підтвердити кваліфікацію
  [Arguments]   ${username}   ${tender_uaid}    ${index}
  ${index}=  inc  ${index}
  click element  xpath=//div[@data-block="ql"][${index}]//label[@data-atid="eligible"]
  click element  xpath=//div[@data-block="ql"][${index}]//label[@data-atid="qualified"]
  click element  xpath=//div[@data-block="ql"][${index}]//button[contains(@id, 'bt_ql_SendDecion')]
  sleep  3
  Wait Until Element Contains  id=page_shown  Y  10

Завантажити документ у кваліфікацію
  [Arguments]  ${username}  ${filepath}  ${tender_uaid}  ${index}
  ${index}=  inc  ${index}
  Click Element  xpath=//div[@data-block="ql"][${index}]//button[contains(@id, 'btn_documents_add')]
  Choose File  xpath=//form[@id='upload_form']//input[@name='file']  ${filepath}
  Завантажити документ рішення кваліфікаційної комісії тендеру  ${filepath}  ${index}

Відхилити кваліфікацію
  [Arguments]   ${username}   ${tender_uaid}    ${index}
  ${index}=  inc  ${index}
  click element  xpath=//div[@data-block="ql"][${index}]//label[@data-atid="decision_reject"]
  Wait Until Element Is Visible  xpath=//div[@data-block="ql"][${index}]//button[contains(@id,"bt_ql_set_title_")]
  click element  xpath=//div[@data-block="ql"][${index}]//button[contains(@id,"bt_ql_set_title_")]
  
  Select From List By Index  id=sl_theme  0
  click element  id=bt_award_set_title_id
  sleep  1
  Run keyword if  '${procurement_method_type}' != 'closeFrameworkAgreementUA'  input text  xpath=//div[@data-block="ql"][${index}]//textarea[contains(@id, 'description')]  123
  click element  xpath=//div[@data-block="ql"][${index}]//button[contains(@id, 'bt_ql_SendDecion')]
  sleep  3
  Wait Until Element Contains  id=page_shown  Y  10

Скасувати кваліфікацію
  [Arguments]   ${username}   ${tender_uaid}    ${index}
  ${index}=  inc  ${index}
  click element  xpath=//div[@data-block="ql"][${index}]//button[contains(@id, 'bt_ql_Cancel')]
  sleep  3
  Wait Until Element Contains  id=page_shown  Y  10

Затвердити остаточне рішення кваліфікації
  [Arguments]   ${username}   ${tender_uaid}
  Wait Until Element Contains  id=page_shown  Y  10
  click element  id=btn_pre_qualification_stand_still
  sleep  120
  Reload Page
  Wait Until Element Contains  id=page_shown  Y  10

  ${endDate}=  Get Text   id=tPosition_qualificationPeriod_endDate
  ${qualificationPeriod}=  Create Dictionary
  ...  endDate=${endDate}
  Set To Dictionary  ${USERS.users['${tender_owner}'].tender_data}  qualificationPeriod=${qualificationPeriod}

################################## Кваліфікація ################################

Скасування рішення кваліфікаційної комісії
  [Arguments]  ${username}   ${tender_uaid}  ${index}
  ${index}=  inc  ${index}
#  uub.Пошук тендера по ідентифікатору    ${username}  ${tender_uaid}
  Wait Until Element Contains  id=page_shown  Y  10
  Wait Until Page Contains Element  xpath=//div[@data-block="award"][${index}]//button[contains(@id, 'bt_award_Cancel')]
  Click Element  xpath=//div[@data-block="award"][${index}]//button[contains(@id, 'bt_award_Cancel')]
  sleep  3
  Wait Until Element Contains  id=page_shown  Y  10

Завантажити документ рішення кваліфікаційної комісії
  [Arguments]  ${username}  ${filepath}  ${tender_uaid}  ${index}
  ${index}=  inc  ${index}
  Завантажити документ рішення кваліфікаційної комісії тендеру  ${filepath}  ${index}

Завантажити документ рішення кваліфікаційної комісії тендеру
  [Arguments]  ${filepath}  ${index}
  Click Element  xpath=//div[@data-block="award"][${index}]//button[contains(@id, 'btn_documents_add')]
  Choose File  xpath=(//form[@id='upload_form']//input[@name='file'])  ${filepath}
  Reload Page
  Wait Until Element Contains  id=page_shown  Y  10

Підтвердити постачальника
  [Arguments]  ${username}  ${tender_uaid}  ${index}
  ${index}=  inc  ${index}
  Wait Until Element Contains  id=page_shown  Y  10
  Wait Until Page Contains Element  xpath=//div[@data-block="award"][${index}]//button[contains(@id, 'bt_award_public')]
  click element  xpath=//div[@data-block="award"][${index}]//button[contains(@id, 'bt_award_public')]
  sleep  3
  Wait Until Element Contains  id=page_shown  Y  10

Затвердити постачальників
  [Arguments]  ${username}  ${tender_uaid}
  Reload Page
  Wait Until Element Contains  id=page_shown  Y  10
  Wait Until Page Contains Element  id=btn_qualification_stand_still
  click element  id=btn_qualification_stand_still
  sleep  3
  Wait Until Element Contains  id=page_shown  Y  10
	
################################## Договір ################################

Редагувати угоду
  [Arguments]    ${username}   ${tender_uaid}   ${index}    ${fieldname}    ${fieldvalue}
##debug    uub.Пошук тендера по ідентифікатору    ${username}  ${tender_uaid}

  ${app_value}=  Run Keyword If  '${fieldname}' in ['value.amountNet', 'value.amount']  convert to string  ${fieldvalue}
  ...  ELSE  Set Variable  ${fieldvalue}

  ${is_edit}=  Run Keyword And Return Status    Element Should Not Be Visible    xpath=(//div[@id="pnAwardList"]//input[contains(@id, 'contractNumber')])[last()]
  Run Keyword If  ${is_edit}  Run keywords
  ...  Reload Page
  ...  AND  Wait Until Element Contains  id=page_shown  Y  10

  ${contractNumber}=  Get Value   xpath=(//div[@id="pnAwardList"]//input[contains(@id, 'contractNumber')])[last()]
  Run Keyword If  '${contractNumber}' == ''  Встановити початкові дані договору  ${index}
  
  Run Keyword If  '${fieldname}' == 'value.amountNet'  Input text  xpath=(//div[@id="pnAwardList"]//input[@data-atid="value.amountNet"])[last()]  ${app_value}
  ...  ELSE IF  '${fieldname}' in ['value.amount', 'value.amount']  Input text  xpath=(//div[@id="pnAwardList"]//input[@data-atid="value.amount"])[last()]  ${app_value}
  ...  ELSE  Set Variable  ${fieldvalue}

  Click Element  xpath=(//div[@id="pnAwardList"]//button[contains(@id, 'bt_contract_save')])[last()]

Встановити початкові дані договору
  [Arguments]    ${index}
  ${now}=  op_robot_tests.tests_files.service_keywords.Get Current Tzdate
  ${now_DMY}=  convert_ISO_DMY  ${now}
  ${now_HM}=  convert_ISO_HM  ${now}
  
  input text  xpath=(//div[@id="pnAwardList"]//input[contains(@id, 'contractNumber')])[last()]  12345 
  input text  xpath=(//div[@id="pnAwardList"]//input[contains(@id, 'dateSigned_Date')])[last()]  ${now_DMY} 
  input text  xpath=(//div[@id="pnAwardList"]//input[contains(@id, 'dateSigned_Time')])[last()]  ${now_HM} 
  input text  xpath=(//div[@id="pnAwardList"]//input[contains(@id, 'period_startDate')])[last()]  ${now_DMY} 
  input text  xpath=(//div[@id="pnAwardList"]//input[contains(@id, 'period_endDate')])[last()]  ${now_DMY} 

Встановити дату підписання угоди
  [Arguments]    ${username}   ${tender_uaid}   ${contract_index}    ${fieldvalue}

  ${str}=  convert_ISO_DMY  ${fieldvalue}
  Input text  xpath=(//div[@id="pnAwardList"]//input[@data-atid="dateSigned.date"])[last()]  ${str}
  ${str}=  convert_ISO_HM  ${fieldvalue}
  Input text  xpath=(//div[@id="pnAwardList"]//input[@data-atid="dateSigned.time"])[last()]  ${str}
  Click Element  xpath=(//div[@id="pnAwardList"]//button[contains(@id, 'bt_contract_save')])[last()]

Вказати період дії угоди
  [Arguments]    ${username}   ${tender_uaid}   ${contract_index}    ${startDate}    ${endDate}
  ${str}=  convert_ISO_DMY  ${startDate}
  Input text  xpath=(//div[@id="pnAwardList"]//input[@data-atid="startDate"])[last()]  ${str}
  ${str}=  convert_ISO_DMY  ${endDate}
  Input text  xpath=(//div[@id="pnAwardList"]//input[@data-atid="endDate"])[last()]  ${str}
  Click Element  xpath=(//div[@id="pnAwardList"]//button[contains(@id, 'bt_contract_save')])[last()]
  sleep  2	
  Wait Until Element Contains  id=page_shown  Y  10

Завантажити документ в угоду
  [Arguments]    ${username}  ${file_path}  ${tender_uaid}  ${contract_index}
  Click Element  xpath=(//div[@id="pnAwardList"]//button[contains(@id, 'btn_documents_add')])[last()]
  Choose File  xpath=(//form[@id='upload_form']//input[@name='file'])  ${filepath}
  Reload Page

Очікування закінчення оскарження договору
    Wait Until Keyword Succeeds     15x      50          Run Keywords
    ...   Sleep  2
    ...   AND     Reload Page
    ...   AND     Wait Until Element Contains  id=page_shown  Y  10
    ...   AND     Wait Until Element Is Not Visible  id=pn_complaintPeriod

Підтвердити підписання контракту
  [Arguments]    ${username}   ${tender_uaid}   ${contract_num}
  Click Element  xpath=(//div[@id="pnAwardList"]//button[contains(@id, 'bt_contract_save')])[last()]
  Sleep  1
  Wait Until Element Contains  id=page_shown  Y  10
  Click Element  xpath=(//div[@id="pnAwardList"]//button[contains(@id, 'bt_contract_register')])[last()]

################################## Рамкові угоди ################################

Встановити ціну за одиницю для контракту
  [Arguments]  ${username}  ${tender_uaid}  ${contract_data}
  Wait Until Element Contains  id=page_shown  Y  30
  
  ${agreementNumber}=  Get Value  xpath=//div[@id="pn_agreement_content"]//input[contains(@id, 'agreementNumber')]

  Run Keyword If  '${agreementNumber}' == ''  Встановити початкові дані угоди
  
  ${app_value}=  convert to string  ${contract_data.data.unitPrices[0].value.amount}
  Input text  xpath=//input[@id='e_agreement_contract_item_${contract_data.data.id}_${contract_data.data.unitPrices[0].relatedItem}_value_amount']  ${app_value}	
  Click Element  xpath=(//div[@id="pn_agreement_List"]//button[contains(@id, 'bt_agreement_save')])[last()]

Встановити початкові дані угоди
  ${period}=  create_fake_period  ${100}  ${0}  ${0}
  ${period}=  munch_dict  arg=${period}

  ${now}=  op_robot_tests.tests_files.service_keywords.Get Current Tzdate
  ${now_DMY}=  convert_ISO_DMY  ${now}
  ${now_HM}=  convert_ISO_HM  ${now}
  input text  xpath=//div[@id="pn_agreement_List"]//input[contains(@id, 'agreementNumber')]  12345 
  input text  xpath=//div[@id="pn_agreement_List"]//input[contains(@id, 'dateSigned_Date')]  ${now_DMY} 
  input text  xpath=//div[@id="pn_agreement_List"]//input[contains(@id, 'dateSigned_Time')]  ${now_HM} 
  
  ${str}=  convert_ISO_DMY  ${period.startDate}
  input text  xpath=//div[@id="pn_agreement_List"]//input[contains(@id, 'period_startDate')]  ${str} 
  ${str}=  convert_ISO_DMY  ${period.endDate}
  input text  xpath=//div[@id="pn_agreement_List"]//input[contains(@id, 'period_endDate')]  ${str} 

  ${els_value_amount}=  Get WebElements  xpath=//div[@id="pn_agreement_List"]//input[contains(@id, 'e_agreement_contract_item_') and contains(@id, '_value_amount')]
  :FOR  ${el}  IN  @{els_value_amount}
  \  Input text  ${el}  1

Зареєструвати угоду
  [Arguments]  ${username}  ${tender_uaid}  ${period}
  Wait Until Element Contains  id=page_shown  Y  30
  ${now}=  op_robot_tests.tests_files.service_keywords.Get Current Tzdate
  ${now_DMY}=  convert_ISO_DMY  ${now}
  ${now_HM}=  convert_ISO_HM  ${now}
  ${period}=  munch_dict  arg=${period}

  log  ${period}
  input text  xpath=//div[@id="pn_agreement_List"]//input[contains(@id, 'agreementNumber')]  12345 
  input text  xpath=//div[@id="pn_agreement_List"]//input[contains(@id, 'dateSigned_Date')]  ${now_DMY} 
  input text  xpath=//div[@id="pn_agreement_List"]//input[contains(@id, 'dateSigned_Time')]  ${now_HM} 
  
  ${str}=  convert_ISO_DMY  ${period.startDate}
  input text  xpath=//div[@id="pn_agreement_List"]//input[contains(@id, 'period_startDate')]  ${str} 
  ${str}=  convert_ISO_DMY  ${period.endDate}
  input text  xpath=//div[@id="pn_agreement_List"]//input[contains(@id, 'period_endDate')]  ${str} 

  Click Element  xpath=(//div[@id="pn_agreement_List"]//button[contains(@id, 'bt_agreement_save')])
  Wait Until Element Contains  id=page_shown  Y  30
  Click Element  xpath=(//div[@id="pn_agreement_List"]//button[contains(@id, 'bt_agreement_public')])

Пошук угоди по ідентифікатору
  [Arguments]  ${username}  ${AGREEMENT_UAID}  ${save_key}=tender_data
  go to  ${BROKERS['uub'].tenders_page}
  Wait Until Page Contains Element  id=btFilterAgreement
  Sleep  1
  Click Element  id=btClearFilter
  Wait Until Page Contains Element  id=btFilterNumber
  Click Element  id=btFilterAgreement
  Wait Until Page Contains Element  xpath=//input[contains(@id, "ew_fv_")]
  Input Text  xpath=//input[contains(@id, "ew_fv_")]  ${AGREEMENT_UAID}
  Click Element  id=btnFilter
  Sleep  1
  Wait Until Page Contains Element  xpath=//a[contains(@id, "title")]
  Sleep  1
  Click Element  xpath=//a[contains(@id, "title")]
  Wait Until Element Contains  id=page_shown  Y  10
 
Отримати інформацію із угоди
  [Arguments]  ${username}  ${agreement_uaid}  ${field_name}
  ${return_value}=  Run Keyword If  'changes' in '${fieldname}'  Отримати інформацію по id про ${fieldname}
  ...  Else  Get text  xpath=//div[@id="pn_agreement_List"]//*[@data-atid="${fieldname}" and not(contains(@style,'display: none'))]
  [Return]  ${return_value}

Отримати інформацію по id про changes[${index}].${fieldname}
  ${index}=  inc  ${index}

  ${return_value}=  Run Keyword If  'modifications' in '${fieldname}'  Отримати інформацію по id про [${index}] ${fieldname}  
  ...  Else  Get text  xpath=//div[@data-block="agreement_change"][${index}]//*[@data-atid="${fieldname}" and not(contains(@style,'display: none'))]
  
  ${return_value}=   Run Keyword If  'addend' in '${fieldname}'  convert to number  ${return_value.replace(" ", "").replace(',', '.')}
  ...  ELSE IF  'factor' in '${fieldname}'  convert to number  ${return_value.replace(" ", "").replace(',', '.')}
  ...  ELSE  Set Variable  ${return_value}
  [Return]  ${return_value}

Отримати інформацію по id про ${index_change} modifications[${index}].${fieldname}
  ${index}=  inc  ${index}
  ${return_value}=  Get text  xpath=//div[@data-block="agreement_change"][${index_change}]//div[@data-block="modification"][${index}]//*[@data-atid="${fieldname}" and not(contains(@style,'display: none'))]
  [Return]  ${return_value}

Отримати доступ до угоди
  [Arguments]  ${username}  ${agreement_uaid}
  Log  ${agreement_uaid}

Завантажити документ в рамкову угоду
  [Arguments]  ${username}  ${filepath}  ${agreement_uaid}
  Log  ${filepath}
  
Внести зміну в угоду
  [Arguments]  ${username}  ${agreement_uaid}  ${change_data}
  log  ${change_data}
  Wait Until Element Is Visible  xpath=//button[contains(@id,'bt_add_agreement_change_')]
  Click Element  xpath=//button[contains(@id,'bt_add_agreement_change_')]
  ${rationaleType}=  Set Variable  ${change_data.data.rationaleType}

  Select From List By Value  xpath=//div[@data-block="agreement_change"][last()]//select[contains(@id, 'rationaleType')]  ${rationaleType}
  input text  xpath=//div[@data-block="agreement_change"][last()]//textarea[contains(@id, '_rationale')]  ${change_data.data.rationale} 
  
  Run Keyword If  '${rationaleType}' != 'partyWithdrawal'  Input Text  xpath=//div[@data-block="agreement_change"][last()]//input[contains(@id, '_factor')]  1

  Click Element  xpath=//div[@data-block="agreement_change"][last()]//button[contains(@id, 'bt_agreement_change_pending_save_loc-change')]
  sleep  5
  Wait Until Element Contains  id=page_shown  Y  10

Оновити властивості угоди
  [Arguments]  ${username}  ${agreement_uaid}  ${change_data}
  log  ${change_data}

  Wait Until Element Is Visible  xpath=//div[@data-block="agreement_change"][last()]//button[contains(@id, 'bt_agreement_change_pending_save_')]

  ${rationaleType}=    Get text  xpath=//div[@data-block="agreement_change"][last()]//span[@data-atid="rationaleType" and not(contains(@style,'display: none'))]
  
  ${modification}=  Set variable  ${change_data.data.modifications[0]}
  ${has_contractId}=  Run Keyword And Return Status  Dictionary Should Contain Key  ${modification}  contractId

  ${select_name}=  Set Variable If  ${has_contractId}  contractId  itemId
  ${select_value}=  Get From Dictionary  ${modification}  ${select_name}

  ${has_addend}=  Run Keyword And Return Status  Dictionary Should Contain Key  ${modification}  addend
  ${has_factor}=  Run Keyword And Return Status  Dictionary Should Contain Key  ${modification}  factor
  ${field_name}=  Set Variable If  ${has_addend}  addend  
  ...  ${has_factor}  factor
  ...  contractId
  
  ${field_value}=  Get From Dictionary  ${modification}  ${field_name}

  Run Keyword And Return If  '${field_name}' == 'contractId' or '${field_name}' == 'itemId'
  ...  Select From List By Value  xpath=//div[@data-block="agreement_change"][last()]//select[contains(@id, '_${select_name}')]  ${field_value}
  Select From List By Value  xpath=//div[@data-block="agreement_change"][last()]//select[contains(@id, '_${select_name}')]  ${select_value}

  ${factor_percent}=  Run Keyword If  '${field_name}' == 'factor'  Evaluate  (${field_value}-1)*100
  ${factor_percent}=  Convert To String  ${factor_percent}

  ${field_value}=  Run Keyword If  '${field_name}' == 'addend'  Convert To String  ${field_value}
  
  Run Keyword If  '${field_name}' == 'addend' and ('taxRate' in '${TEST_NAME}' or 'itemPriceVariation' in '${TEST_NAME}')
    ...  Run keywords
    ...  Input Text  xpath=//div[@data-block="agreement_change"][last()]//input[contains(@id, '_addend')]  ${field_value}
	...  AND  Run Keyword If  '${rationaleType}' in ['taxRate']  clear element text  xpath=//div[@data-block="agreement_change"][last()]//input[contains(@id, '_factor')]
	
  Run Keyword If  '${field_name}' == 'factor' and ('thirdParty' in '${TEST_NAME}' or 'itemPriceVariation' in '${TEST_NAME}')
    ...  Run keywords
    ...  Input Text  xpath=//div[@data-block="agreement_change"][last()]//input[contains(@id, '_factor')]  ${factor_percent}
    ...  AND  Run Keyword If  '${rationaleType}' in ['taxRate']  clear element text  xpath=//div[@data-block="agreement_change"][last()]//input[contains(@id, '_addend')]

  Click Element  xpath=//div[@data-block="agreement_change"][last()]//button[contains(@id, 'bt_agreement_change_pending_save_')]
  sleep  5
  Wait Until Element Contains  id=page_shown  Y  10

Завантажити документ для зміни у рамковій угоді
  [Arguments]  ${username}  ${filepath}  ${agreement_uaid}  ${item_id}
  Wait Until Element Is Visible  xpath=//div[@data-block="agreement_change"][last()]//button[contains(@id, 'btn_documents_add')]
  Click Element  xpath=//div[@data-block="agreement_change"][last()]//button[contains(@id, 'btn_documents_add')]

  Choose File  xpath=(//form[@id='upload_form']//input[@name='file'])  ${filepath}
  Wait Until Page Contains  завантажено  10

Застосувати зміну для угоди
  [Arguments]  ${username}  ${agreement_uaid}  ${dateSigned}  ${status}
  Wait Until Element Is Visible  xpath=//div[@data-block="agreement_change"][last()]//button[contains(@id, 'bt_agreement_change_public_')]
  Run Keyword If  '${status}' == 'active'  Click Element  xpath=//div[@data-block="agreement_change"][last()]//button[contains(@id, 'bt_agreement_change_public_')]
  Run Keyword If  '${status}' == 'cancelled'  Click Element  xpath=//div[@data-block="agreement_change"][last()]//button[contains(@id, 'bt_agreement_change_сancel_')]
  sleep  5
  Wait Until Element Contains  id=page_shown  Y  10
  
  
################################## competitiveDialogue #######################

Перевести тендер на статус очікування обробки мостом
    [Arguments]    ${username}   ${tender_uaid}
    Wait Until Keyword Succeeds  300  10  Run Keywords
    ...   Sleep  3
    ...   AND  Reload Page
    ...   AND  sleep   2
    ...   AND  Wait Until Element Is Enabled  id=btn_active_stage2_waiting
    sleep  3
    click element   id=btn_active_stage2_waiting
    sleep  10
  Wait Until Element Contains  id=page_shown  Y  10

Отримати тендер другого етапу та зберегти його
    [Arguments]    ${username}   ${tender_uaid}
    uub.Пошук тендера по ідентифікатору    ${username}  ${tender_uaid}

Активувати другий етап
  [Arguments]    ${username}   ${tender_uaid}
  ${period}=  create_fake_period  ${0}  ${0}  ${20}
  ${period}=  munch_dict  arg=${period}
  ${str}=  convert_ISO_DMY  ${period.endDate}
  ${str_HM}=  convert_ISO_HM  ${period.endDate}
  input text  id=dtpPosition_tenderPeriod_endDate_Date  ${str}
  input text  id=ePosition_tenderPeriod_endDate_Time  ${str_HM}
  click element  id=btnPublic
  Wait Until Element Contains  id=page_shown  Y  10

  ${criterias}=  Get text  id=criteria_contennt
  ${criterias}=  json_load  ${criterias}
  Set Global Variable  ${criterias}
  ${need_reg_criteria}=  Set variable  ${True}
  Set Global Variable  ${need_reg_criteria}
  Set Global Variable  ${first_search}  ${TRUE}

############################### Скасування ###################################################

Перейти до сторінки скаувань
  Wait Until Page Contains Element  id=cancels_ref 
  Click Element  id=cancels_ref
  Wait Until Element Contains  id=page_shown  Y  10

Створити скаування
  [Arguments]  ${username}  ${tender_uaid}  ${cancellation_reason}  ${cancellation_reasonType}  ${doc_path}  ${description}
  Wait Until Element Contains  id=page_shown  Y  10
  
  Wait Until Element Is Visible  xpath=//button[contains(@id, 'btDraft_')]
  Select From List By Value  xpath=//div[@id="pnList"]//div[@data-block="cancellation"][last()]//select[contains(@id, '_reasonType')]  ${cancellation_reasonType}
  Input text  xpath=//div[@id="pnList"]//div[@data-block="cancellation"][last()]//textarea[contains(@id, '_reason')]  ${cancellation_reason}
  Click Element  xpath=//div[@id="pnList"]//div[@data-block="cancellation"][last()]//button[contains(@id, 'btDraft_')]
  sleep  1
  Wait Until Element Contains  id=page_shown  Y  10

  Wait Until Element Is Visible  xpath=//div[@id="pnList"]//div[@data-block="cancellation"][last()]//button[contains(@id, "btn_documents_add")]

  Click Element  xpath=//div[@id="pnList"]//div[@data-block="cancellation"][last()]//button[contains(@id, "btn_documents_add")][last()]
  ${file_path}  ${file_name}  ${file_content}=  create_fake_doc
  Choose File  xpath=//form[@id='upload_form']//input[@name='file']  ${doc_path}
  Click Element  //div[@id="diagFileUpload"]//button[@data-atid="btClose"]
  Remove File  ${file_path}

  Wait Until Element Is Visible  xpath=//div[@id="pnList"]//div[@data-block="cancellation"][last()]//button[contains(@id, 'btActivate_')]
  Click Element  xpath=//div[@id="pnList"]//div[@data-block="cancellation"][last()]//button[contains(@id, 'btActivate_')]
  sleep  2
  Wait Until Element Contains  id=page_shown  Y  10


Скасувати закупівлю
  [Arguments]  ${username}  ${tender_uaid}  ${cancellation_reason}  ${cancellation_reasonType}  ${doc_path}  ${description}
  Wait Until Page Contains Element  id=btnСancel 
  Click Element  id=btnСancel
  Створити скаування  ${username}  ${tender_uaid}  ${cancellation_reason}  ${cancellation_reasonType}  ${doc_path}  ${description} 
  
Скасувати лот
  [Arguments]  ${username}  ${tender_uaid}  ${lot_id}  ${cancellation_reason}  ${cancellation_reasonType}  ${doc_path}  ${description}
  Wait Until Page Contains Element  xpath=(//div[@data-block-id='${lot_id}']//button[contains(@id, 'btn_lot_cancel_')]) 
  Click Element  xpath=(//div[@data-block-id='${lot_id}']//button[contains(@id, 'btn_lot_cancel_')])
  Створити скаування  ${username}  ${tender_uaid}  ${cancellation_reason}  ${cancellation_reasonType}  ${doc_path}  ${description} 

############################### Сервіс ###################################################

Отримати інформацію із документа
  [Arguments]  ${username}  ${tender_uaid}  ${doc_id}  ${field}
  Wait Until Element Contains  id=page_shown  Y  10
  ${return_value}=  Get Text   xpath=//div[@data-block-id="${doc_id}"]//*[@data-atid='${field}']
  [Return]  ${return_value}

Отримати документ
  [Arguments]  ${username}  ${tender_uaid}  ${doc_id}
  Wait Until Element Contains  id=page_shown  Y  10
  ${file_name}=   Get Text   xpath=//div[@data-block-id="${doc_id}"]//a[@data-atid='title']
  ${url}=   Get Element Attribute    xpath=//div[@data-block-id="${doc_id}"]//a[@data-atid='title']@href
  download_file   ${url}  ${file_name.split('/')[-1]}  ${OUTPUT_DIR}
  [Return]  ${file_name.split('/')[-1]}

Отримати документ до лоту
  [Arguments]  ${username}  ${tender_uaid}  ${lot_id}  ${doc_id}
  ${file_name}=   uub.Отримати документ  ${tender_uaid}  ${doc_id}
  [Return]  ${file_name}

Отримати документ до договору
  [Arguments]  ${username}  ${CONTRACT_UAID}  ${doc_id}
  ${file_name}=   uub.Отримати документ  ${tender_uaid}  ${doc_id}
  [Return]  ${file_name}

Отримати інформацію про ${fieldname}
  ${fieldname_end}=   Remove String Using Regexp  ${fieldname}  .*].
  ${return_value}=  Отримати інформацію з елементу за шляхом //*[@name = '${fieldname}']
  ${return_value}=  Run Keyword If  '${fieldname_end}' == 'tenderAttempts'  Convert To Integer  ${return_value.replace(' ', '').replace(',', '.')}
  ...  ELSE IF  '${fieldname_end}' == 'minNumberOfQualifiedBids'  Convert To Integer  ${return_value.replace(' ', '').replace(',', '.')}
  ...  ELSE IF  '${fieldname_end}' == 'budget.amount'  Convert To Number  ${return_value.replace(' ', '').replace(',', '.')}
  ...  ELSE IF  '${fieldname_end}' == 'value.amount'  Convert To Number  ${return_value.replace(' ', '').replace(',', '.')}
  ...  ELSE IF  '${fieldname_end}' == 'quantity'  Convert To Number  ${return_value.replace(' ', '').replace(',', '.')}
  ...  ELSE IF  '${fieldname_end}' == 'Date'  convert_date_time_to_iso  ${return_value}
  ...  ELSE IF  '${fieldname_end}' == 'date'  convert_date_time_to_iso  ${return_value}
  ...  ELSE  Set Variable  ${return_value}
  [Return]  ${return_value}

Отримати інформацію з елементу за шляхом ${elementname}
  ${return_value}=  Get Value  xpath=//div[@id='pnContent']${elementname}
  ${status}=   Run Keyword And Return Status   Should Be Equal   ${return_value}   ${None}
  ${return_value}=  Run Keyword If  ${status}  Get Text  xpath=//div[@id='pnContent']${elementname}
  ...  ELSE  Set Variable  ${return_value}
  [return]  ${return_value}

Отримати інформацію з елементу сторінки за шляхом ${elementname}
  ${return_value}=  Get Value  xpath=${elementname}
  ${status}=   Run Keyword And Return Status   Should Be Equal   ${return_value}   ${None}
  ${return_value}=  Run Keyword If  ${status}  Get Text  xpath=${elementname}
  ...  ELSE  Set Variable  ${return_value}
  [return]  ${return_value}


Отримати інформацію із предмету
  [Arguments]  ${username}  ${tender_uaid}  ${item_id}  ${fieldname}
  ${present}=  Run Keyword And Return Status  Element Should Not Be Visible  id=position_ref
  Run Keyword if  ${present}  Wait Until Element Contains  id=page_shown  Y  10

  ${return_value}=   Get text  xpath=//div[starts-with(@id, 'pn_w_item') and contains(@class, '${item_id}')]//*[@data-atid="${fieldname}" and not(contains(@style,'display: none'))]

  ${return_value}=   Run Keyword If  '${fieldname}' == 'quantity'  convert to number  ${return_value.replace(',', '.')}
  ...  ELSE  Set Variable  ${return_value}

  [return]  ${return_value}

Отримати інформацію із нецінового показника
  [Arguments]   ${username}   ${tender_uaid}   ${feature_id}   ${fieldname}
  ${present}=  Run Keyword And Return Status  Element Should Not Be Visible  id=position_ref
  Run Keyword if  ${present}  Wait Until Element Contains  id=page_shown  Y  10
  
  ${return_value}=  Отримати інформацію з елементу за шляхом //div[@data-block-id="${feature_id}"]//*[@data-atid="${fieldname}"]
  [return]  ${return_value}

Отримати інформацію із лоту
  [Arguments]   ${username}   ${tender_uaid}   ${lot_id}   ${fieldname}
  ${present}=  Run Keyword And Return Status  Element Should Not Be Visible  id=position_ref
  Run Keyword if  ${present}  Wait Until Element Contains  id=page_shown  Y  10

  ${return_value}=  Run Keyword If  'currency' in '${fieldname}'  Get Text   id=tPosition_value_currency
  ...  ELSE IF  'valueAddedTaxIncluded' in '${fieldname}'  is_checked  cbPosition_value_valueAddedTaxIncluded
  ...  ELSE IF  'fundingKind' == '${fieldname}'  Get text  id=tPosition_fundingKind
  ...  ELSE  Get text  xpath=(//div[@data-block="lot"])//*[@data-atid="${fieldname}" and not(contains(@style,'display: none'))]

  ${return_value}=   Run Keyword If  '.amount' in '${fieldname}' or '${fieldname}' == 'minimalStepPercentage' or '${fieldname}' == 'yearlyPaymentsPercentageRange' Convert to number  ${return_value.replace(',', '.')}
  ...  ELSE  Set Variable  ${return_value}

  Run Keyword If  'value.amount' in '${fieldname}'  Run Keywords  
  ...  Set_To_Object  ${USERS.users['${tender_owner}'].tender_data.data}  lots[0].value.valueAddedTaxIncluded  ${tender_data.data.value.valueAddedTaxIncluded}
  ...  AND  Set To Dictionary  ${USERS.users['${tender_owner}'].tender_data}  data=${USERS.users['${tender_owner}'].tender_data.data}

  [Return]  ${return_value}

Отримати інформацію із предмету items[${item_id}].${fieldname}
  ${return_value}=  Run Keyword If  '${fieldname}' == 'description'
  ...  Get Text  xpath=(//div[@id = 'pn_w_item_${item_id}']//span[contains(@id, 'description')]) 
  ...  ELSE IF  '${fieldname}' == 'classification.scheme'  Get Text  xpath=(//div[@id = 'pn_w_item_${item_id}']//span[contains(@id, 'classification_scheme')]) 
  ...  ELSE IF  '${fieldname}' == 'classification.id'  Get Text  xpath=(//div[@id = 'pn_w_item_${item_id}']//span[contains(@id, 'classification_id')]) 
  ...  ELSE IF  '${fieldname}' == 'classification.description'  Get Text  xpath=(//div[@id = 'pn_w_item_${item_id}']//span[contains(@id, 'classification_description')]) 
  ...  ELSE IF  '${fieldname}' == 'unit.name'  Get Text  xpath=(//div[@id = 'pn_w_item_${item_id}']//span[contains(@id, 'unit_name') and contains(@id, 'tslw_item')]) 
  ...  ELSE IF  '${fieldname}' == 'unit.code'  Get Text  xpath=(//div[@id = 'pn_w_item_${item_id}']//span[contains(@id, 'unit_code') and contains(@id, 'tw_item')]) 
  ...  ELSE IF  '${fieldname}' == 'quantity'  Get Text  xpath=(//div[@id = 'pn_w_item_${item_id}']//span[contains(@id, 'quantity')]) 
  [return]  ${return_value}

Внести зміни до елементу за шляхом 
  [Arguments]  ${elementname}  ${fieldname}  ${fieldvalue}
  ${fieldvalue}=  Run Keyword If  '${fieldname}' == 'value.amount'  get_str  ${fieldvalue}
  ...  ELSE IF  '${fieldname}' == 'minimalStep.amount'  get_str  ${fieldvalue}
  ...  ELSE IF  '${fieldname}' == 'registrationFee.amount'  get_str  ${fieldvalue}
  ...  ELSE IF  '${fieldname}' == 'guarantee.amount'  get_str  ${fieldvalue}
  ...  ELSE IF  '${fieldname}' == 'quantity'  get_str  ${fieldvalue}
  ...  ELSE IF  '${fieldname}' == 'auctionPeriod.startDate'  convert_ISO_DMY  ${fieldvalue}
  ...  ELSE  Set Variable  ${fieldvalue}
  Input text  xpath=(//div[@id='page_content']${elementname})  ${fieldvalue}
  Click Element  id=btnPublic

Внести дату та час
  [Arguments]  ${prefix}  ${_value}
  ${_Date}=  convert_ISO_DMY  ${_value}
  ${_Time}=  convert_ISO_HM  ${_value}
  Input Text  id=dtp${prefix}_Date  ${_Date}
  Input Text  id=e${prefix}_Time  ${_Time}

