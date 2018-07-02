*** Settings ***
Library  String
Library  Selenium2Library
Library  Collections
Library  uub_service.py

*** Variables ***
${locator.edit.description}  id=ePosition_description
${locator.title}  id=tePosition_title
${locator.description}  id=tePosition_description
${locator.edit.minimalStep.amount}  id=ePosition_minimalStep_amount
${locator.edit.guarantee.amount}  id=ePosition_guarantee_amount
${locator.edit.value.amount}  id=ePosition_value_amount
${locator.minimalStep.amount}  id=tPosition_minimalStep_amount
${locator.guarantee.amount}  id=tPosition_guarantee_amount
${locator.value.amount}  id=tPosition_value_amount
${locator.value.valueAddedTaxIncluded}  id=cbPosition_value_valueAddedTaxIncluded
${locator.value.currency}  id=tslPosition_value_currency
${locator.auctionPeriod.startDate}  id=tdtpPosition_auctionPeriod_startDate_Date
${locator.enquiryPeriod.startDate}  id=tdtpPosition_enquiryPeriod_startDate_Date
${locator.enquiryPeriod.endDate}  id=tdtpPosition_enquiryPeriod_endDate_Date
${locator.tenderPeriod.startDate}  id=tPosition_tenderPeriod_startDate_Date
${locator.tenderPeriod.endDate}  id=tPosition_tenderPeriod_endDate_Date
${locator.tenderId}  id=tPosition_tenderID
${locator.procuringEntity.name}  id=tew_Org_0_PE_name
${locator.dgf}  id=tePosition_dgfID
${locator.minNumberOfQualifiedBids}  id=tPosition_minNumberOfQualifiedBids
${locator.eligibilityCriteria}  id=tPosition_eligibilityCriteria
${locator.tenderAttempts}  id=tPosition_tenderAttempts
${locator.procurementMethodType}  id=tPosition_procurementMethodType
${locator.items[0].quantity}  id=tew_item_0_quantity
${locator.items[0].description}  id=tew_item_0_description
${locator.items[0].unit.code}  id=tw_item_0_unit_code
${locator.items[0].unit.name}  id=tslw_item_0_unit_code
${locator.items[0].deliveryAddress.postalCode}  id=tw_item_0_Address_short
${locator.items[0].deliveryAddress.countryName}  id=tw_item_0_Address_short
${locator.items[0].deliveryAddress.region}  id=tw_item_0_Address_short
${locator.items[0].deliveryAddress.locality}  id=tw_item_0_Address_short
${locator.items[0].deliveryAddress.streetAddress}  id=tw_item_0_Address_short
${locator.items[0].deliveryDate.endDate}  id=tdtpw_item_0_deliveryDate_endDate_Date
${locator.items[0].contractPeriod.startDate}  id=tdtpw_item_0_contractPeriod_startDate_Date
${locator.items[0].contractPeriod.endDate}  id=tdtpw_item_0_contractPeriod_endDate_Date
${locator.items[0].classification.scheme}  id=tw_item_0_classification_scheme
${locator.items[0].classification.id}  id=tew_item_0_classification_id
${locator.items[0].classification.description}  id=tw_item_0_classification_description
${locator.items[0].additionalClassifications.scheme}  id=tw_item_0_additionalClassifications_scheme
${locator.items[0].additionalClassifications.id}  id=tew_item_0_additionalClassifications_id
${locator.items[0].additionalClassifications.description}  id=tw_item_0_additionalClassifications_description
${locator.items[1].description}  id=tew_item_1_description
${locator.items[1].contractPeriod.startDate}  id=tdtpw_item_1_contractPeriod_startDate_Date
${locator.items[1].contractPeriod.endDate}  id=tdtpw_item_1_contractPeriod_endDate_Date
${locator.items[1].classification.id}  id=tew_item_1_classification_id
${locator.items[1].classification.description}  id=tw_item_1_classification_description
${locator.items[1].classification.scheme}  id=tw_item_1_classification_scheme
${locator.items[1].additionalClassifications.scheme}  id=tw_item_0_additionalClassifications_scheme
${locator.items[1].additionalClassifications.id}  id=tew_item_0_additionalClassifications_id
${locator.items[1].additionalClassifications.description}  id=tw_item_0_additionalClassifications_description
${locator.items[1].unit.code}  id=tw_item_1_unit_code
${locator.items[1].unit.name}  id=tslw_item_1_unit_code
${locator.items[1].quantity}  id=tew_item_1_quantity
${locator.items[2].description}  id=tew_item_2_description
${locator.items[2].contractPeriod.startDate}  id=tdtpw_item_2_contractPeriod_startDate_Date
${locator.items[2].contractPeriod.endDate}  id=tdtpw_item_2_contractPeriod_endDate_Date
${locator.items[2].classification.id}  id=tew_item_2_classification_id
${locator.items[2].classification.description}  id=tw_item_2_classification_description
${locator.items[2].classification.scheme}  id=tw_item_2_classification_scheme
${locator.items[2].additionalClassifications.scheme}  id=tw_item_0_additionalClassifications_scheme
${locator.items[2].additionalClassifications.id}  id=tew_item_0_additionalClassifications_id
${locator.items[2].additionalClassifications.description}  id=tw_item_0_additionalClassifications_description
${locator.items[2].unit.code}  id=tw_item_2_unit_code
${locator.items[2].unit.name}  id=tslw_item_2_unit_code
${locator.items[2].quantity}  id=tew_item_2_quantity
${locator.questions[0].title}  css=.qa_title
${locator.questions[0].description}  css=.qa_description
${locator.questions[0].date}  css=.qa_question_date
${locator.questions[0].answer}  css=.qa_answer
${locator.cancellations[0].status}  css=.cancel_status
${locator.cancellations[0].reason}  css=.cancel_reason
${locator.contracts.status}  css=.contract_status

*** Keywords ***
Підготувати клієнт для користувача
  [Arguments]  ${username}
  ${alias}=   Catenate   SEPARATOR=   role_  ${username}
  Set Global Variable   ${BROWSER_ALIAS}   ${alias}
  Open Browser  ${USERS.users['${username}'].homepage}  ${USERS.users['${username}'].browser}  alias=${BROWSER_ALIAS}
  Set Window Size  @{USERS.users['${username}'].size}
  Set Window Position  @{USERS.users['${username}'].position}
  Run Keyword If  '${username}' != 'uub_Viewer'  Login  ${username}

Login
  [Arguments]  ${username}
  Input text  id=eLogin  ${USERS.users['${username}'].login}
  Click Element  id=btnLogin

Підготувати дані для оголошення тендера
  [Arguments]  ${username}  ${tender_data}  ${role_name}
  [Return]  ${tender_data}

Додати предмет
  [Arguments]  ${item}  ${index}
  Wait Until Element Is Visible  id=ew_item_${index}_description
  Input text  id=ew_item_${index}_description  ${item.description}
  ${quantity}=  get_str  ${item.quantity}
  Input text  id=ew_item_${index}_quantity  ${quantity}
  Select From List By Value  id=slw_item_${index}_unit_code  ${item.unit.code}
  Select From List By Value  id=slw_item_${index}_classification_scheme  ${item.classification.scheme}
  Input text  id=ew_item_${index}_classification_id  ${item.classification.id}
  Wait Until Element Is Visible  xpath=(//ul[contains(@class, 'ui-autocomplete')]//li//a)
  Click Element  xpath=(//ul[contains(@class, 'ui-autocomplete')]//li//a)
  Input text  id=ew_item_${index}_additionalClassifications_id  ${item.additionalClassifications[0].id}
  Wait Until Element Is Visible  xpath=(//ul[contains(@class, 'ui-autocomplete')]//li//a)
  Click Element  xpath=(//ul[contains(@class, 'ui-autocomplete')]//li//a)
  ${aDate}=  convert_ISO_DMY  ${item.contractPeriod.startDate}
  Input text  id=dtpw_item_${index}_contractPeriod_startDate_Date  ${aDate}
  ${aDate}=  convert_ISO_DMY  ${item.contractPeriod.endDate}
  Input text  id=dtpw_item_${index}_contractPeriod_endDate_Date  ${aDate}
  Input text  id=ew_item_${index}_address_countryName  ${item.deliveryAddress.countryName}
  Input text  id=ew_item_${index}_address_postalCode  ${item.deliveryAddress.postalCode}
  Input text  id=ew_item_${index}_address_region  ${item.deliveryAddress.region}
  Input text  id=ew_item_${index}_address_locality  ${item.deliveryAddress.locality}
  Input text  id=ew_item_${index}_address_streetAddress  ${item.deliveryAddress.streetAddress}

Завантажити документ
  [Arguments]  ${username}  ${filepath}  ${TENDER}
  uub.Пошук тендера по ідентифікатору  ${username}  ${TENDER}
  Wait Until Element Is Visible  xpath=(//*[@id='btn_documents_add'])
  Click Element  id=btn_documents_add
  Choose File  xpath=(//*[@id='upload_form']/input[2])  ${filepath}
  Sleep  2
  Click Element  id=upload_button
  Wait Until Element Contains  id=tFileMessage  Файл завантажено
  Reload Page

Пошук тендера по ідентифікатору
  [Arguments]  ${username}  ${tender_uaid}
  Switch Browser  ${BROWSER_ALIAS}
  Set Global Variable   ${SEARCH_MODE}   'tenders'
  Go to  ${USERS.users['${username}'].default_page}
  Wait Until Element Is Visible  id=btnFilter
  Wait Until Element Contains  id=records_shown  Y
  Input Text  id=ew_fv_0_value  ${tender_uaid}
  Click Element  id=btnFilter
  Wait Until Element Is Visible  id=tw_tr_10_title
  Click Element  id=tw_tr_10_title
  Wait Until Element Is Visible  xpath=(//*[@id='tPosition_status'])

Перейти до сторінки запитань
  Wait Until Element Is Visible  id=questions_ref
  Click Element  id=questions_ref
  Wait Until Element Contains  id=records_shown  Y

Перейти до сторінки відмін
  Wait Until Element Is Visible  id=cancels_ref
  Click Element  id=cancels_ref
  Wait Until Element Contains  id=records_shown  Y

Скасувати закупівлю
  [Arguments]  ${username}  ${tender_uaid}  ${reason}  ${filepath}  ${description}
  uub.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  Wait Until Element Is Visible  xpath=(//*[@id='btnСancel'])
  Click Element  id=btnСancel
  Sleep  2
  Input text  id=e_reason  ${reason}
  Click Element  id=SendCancellation
  Wait Until Element Is Visible  xpath=(//*[@id='pnList']//span[contains(@class, 'add_document')])
  Click Element  xpath=(//*[@id='pnList']//span[contains(@class, 'add_document')])
  Choose File  xpath=(//*[@id='upload_form']/input[2])  ${filepath}
  Sleep  2
  Input text  id=eFile_accessDetails  ${description}
  Click Element  id=upload_button
  Wait Until Element Contains  id=tFileMessage  Файл завантажено
  Reload Page
  Click Element  xpath=(//*[@id='pnList']/div[1]/div[2]/div[2]/span)

Отримати інформацію про cancellations[0].status
  Перейти до сторінки відмін
  Wait Until Element Is Visible  xpath=(//span[contains(@class, 'rec_cancel_status')])
  ${return_value}=  Get text  xpath=(//span[contains(@class, 'rec_cancel_status')])
  [return]  ${return_value}

Отримати інформацію про cancellations[0].reason
  Перейти до сторінки відмін
  Wait Until Element Is Visible  xpath=(//span[contains(@class, 'rec_cancel_reason')])
  ${return_value}=  Get text  xpath=(//span[contains(@class, 'rec_cancel_reason')])
  [return]  ${return_value}

Оновити сторінку з тендером
  [Arguments]  ${username}  ${tender_uaid}
  uub.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}

Отримати інформацію з поля предмету
  [Arguments]  ${username}  ${tender_uaid}  ${item_id}  ${field_name}
  ${return_value}=  Отримати інформацію з елементу за шляхом //div[starts-with(@id, 'pn_w_item') and contains(@class, '${item_id}')]//*[@name= '${field_name}']
  ${return_value}=  Run Keyword If  '${field_name}' == 'contractPeriod.startDate'  uub_service.convert_DMY_ISO  ${return_value}
  ...  ELSE IF  '${field_name}' == 'contractPeriod.endDate'  uub_service.convert_DMY_ISO  ${return_value}
  ...  ELSE IF  '${field_name}' == 'quantity'  Convert To Number  ${return_value.replace(' ', '').replace(',', '.')}
  ...  ELSE  Set Variable  ${return_value}
  [return]  ${return_value}

Отримати інформацію із тендера
  [Arguments]  ${username}  ${tender_uaid}  ${fieldname}
  ${return_value}=  Run Keyword  Отримати інформацію про ${fieldname}
  [return]  ${return_value}

Отримати текст із поля і показати на сторінці
  [Arguments]  ${fieldname}
  ${return_value}=  Отримати інформацію з елементу за шляхом //*[@name = '${fieldname}']
  [return]  ${return_value}

Отримати інформацію про tenderAttempts
  ${return_value}=  Отримати текст із поля і показати на сторінці  tenderAttempts
  ${return_value}=  Convert To Integer  ${return_value}
  [return]  ${return_value}

Отримати інформацію про minNumberOfQualifiedBids
  ${return_value}=  Отримати текст із поля і показати на сторінці  minNumberOfQualifiedBids
  ${return_value}=  Convert To Integer  ${return_value}
  [return]  ${return_value}

Отримати інформацію про eligibilityCriteria
  ${return_value}=  Отримати текст із поля і показати на сторінці  eligibilityCriteria

Отримати інформацію про status
  Reload Page
  Wait Until Element Is Visible  xpath=(//*[@id='tPosition_status'])
  Sleep  2
  ${return_value}=  Get Text  id=tPosition_status
  [return]  ${return_value}

Отримати інформацію про value.amount
  ${return_value}=  Отримати текст із поля і показати на сторінці  value.amount
  ${return_value}=  Convert To Number  ${return_value.replace(' ', '').replace(',', '.')}
  [return]  ${return_value}

Отримати інформацію про minimalStep.amount
  ${return_value}=  Отримати текст із поля і показати на сторінці  minimalStep.amount
  ${return_value}=  Convert To Number  ${return_value.replace(' ', '').replace(',', '.')}
  [return]  ${return_value}

Отримати інформацію про guarantee.amount
  ${return_value}=  Отримати текст із поля і показати на сторінці  guarantee.amount
  ${return_value}=  Convert To Number  ${return_value.replace(' ', '').replace(',', '.')}
  [return]  ${return_value}

Внести зміни в тендер
  [Arguments]  ${username}  ${tender_uaid}  ${fieldname}  ${fieldvalue}
  Wait Until Element Is Visible  ${locator.edit.${fieldname}}  5
  ${fieldvalue}=  Run Keyword If  '${field_name}' == 'value.amount'  get_str  ${fieldvalue}
  ...  ELSE IF  '${field_name}' == 'minimalStep.amount'  get_str  ${fieldvalue}
  ...  ELSE IF  '${field_name}' == 'guarantee.amount'  get_str  ${fieldvalue}
  ...  ELSE  Set Variable  ${fieldvalue}
  Input Text  ${locator.edit.${fieldname}}  ${fieldvalue}
  Click Element  id=btnPublic
  Wait Until Page Contains  Публікацію виконано
  ${result_field}=  Get Value  ${locator.edit.${fieldname}}
  Should Be Equal  ${result_field}  ${fieldvalue}

Отримати інформацію про items[${index}].quantity
  ${return_value}=  Отримати текст із поля і показати на сторінці  items[${index}].quantity
  ${return_value}=  Convert To Number  ${return_value.replace(' ', '').replace(',', '.')}
  [return]  ${return_value}

Отримати інформацію про items[${index}].unit.code
  ${return_value}=  Отримати текст із поля і показати на сторінці  items[${index}].unit.code
  [return]  ${return_value}

Отримати інформацію про items[${index}].unit.name
  ${return_value}=  Отримати текст із поля і показати на сторінці  items[${index}].unit.name
  [return]  ${return_value}

Отримати інформацію про items[${index}].description
  ${return_value}=  Отримати текст із поля і показати на сторінці  items[${index}].description
  [return]  ${return_value}

Отримати інформацію про items[${index}].contractPeriod.startDate
  ${date_value}=  Отримати текст із поля і показати на сторінці  items[${index}].contractPeriod.startDate
  ${return_value}=  uub_service.convert_DMY_ISO  ${date_value}
  [return]  ${return_value}

Отримати інформацію про items[${index}].contractPeriod.endDate
  ${date_value}=  Отримати текст із поля і показати на сторінці  items[${index}].contractPeriod.endDate
  ${return_value}=  uub_service.convert_DMY_ISO  ${date_value}
  [return]  ${return_value}

Отримати інформацію про items[${index}].classification.id
  ${return_value}=  Отримати текст із поля і показати на сторінці  items[${index}].classification.id
  [return]  ${return_value}

Отримати інформацію про items[${index}].classification.scheme
  ${return_value}=  Отримати текст із поля і показати на сторінці  items[${index}].classification.scheme
  [return]  ${return_value}

Отримати інформацію про items[${index}].classification.description
  ${return_value}=  Отримати текст із поля і показати на сторінці  items[${index}].classification.description
  [return]  ${return_value}

Отримати інформацію про items[${index}].additionalClassifications[0].id
  ${return_value}=  Отримати текст із поля і показати на сторінці  items[${index}].additionalClassifications.id
  [return]  ${return_value}

Отримати інформацію про items[${index}].additionalClassifications[0].scheme
  ${return_value}=  Отримати текст із поля і показати на сторінці  items[${index}].additionalClassifications.scheme
  [return]  ${return_value}

Отримати інформацію про items[${index}].additionalClassifications[0].description
  ${return_value}=  Отримати текст із поля і показати на сторінці  items[${index}].additionalClassifications.description


Отримати інформацію про value.currency
  ${return_value}=  Get Selected List Value  slPosition_value_currency
  [return]  ${return_value}

Отримати інформацію про value.valueAddedTaxIncluded
  ${return_value}=  is_checked  cbPosition_value_valueAddedTaxIncluded
  [return]  ${return_value}

Отримати інформацію про auctionID
  ${return_value}=  Отримати текст із поля і показати на сторінці  tenderId
  [return]  ${return_value}

Отримати інформацію про procuringEntity.name
  ${return_value}=  Отримати текст із поля і показати на сторінці  procuringEntity.name
  [return]  ${return_value}

Отримати інформацію про items[0].deliveryLocation.latitude
  ${return_value}=  Отримати текст із поля і показати на сторінці  items[0].deliveryLocation.latitude
  ${return_value}=  Convert To Number  ${return_value}
  [return]  ${return_value}

Отримати інформацію про items[0].deliveryLocation.longitude
  ${return_value}=  Отримати текст із поля і показати на сторінці  items[0].deliveryLocation.longitude
  ${return_value}=  Convert To Number  ${return_value}
  [return]  ${return_value}

Отримати інформацію про auctionPeriod.startDate
  ${date_value}=  Get Text  id=tdtpPosition_auctionPeriod_startDate_Date
  ${time_value}=  Get Text  id=tePosition_auctionPeriod_startDate_Time
  ${return_value}=  convert_date_to_iso  ${date_value}  ${time_value}
  [return]  ${return_value}

Отримати інформацію про auctionPeriod.endDate
  ${date_value}=  Get Text  id=tdtpPosition_auctionPeriod_startDate_Date
  ${time_value}=  Get Text  id=tePosition_auctionPeriod_startDate_Time
  ${return_value}=  convert_date_to_iso  ${date_value}  ${time_value}

Отримати інформацію про tenderPeriod.startDate
  ${date_value}=  Get Text  id=tPosition_tenderPeriod_startDate_Date
  ${time_value}=  Get Text  id=tPosition_tenderPeriod_startDate_Time
  ${return_value}=  convert_date_to_iso  ${date_value}  ${time_value}
  [return]  ${return_value}

Отримати інформацію про tenderPeriod.endDate
  ${date_value}=  Get Text  id=tPosition_tenderPeriod_endDate_Date
  ${time_value}=  Get Text  id=tPosition_tenderPeriod_endDate_Time
  ${return_value}=  convert_date_to_iso  ${date_value}  ${time_value}
  [return]  ${return_value}

Отримати інформацію про enquiryPeriod.startDate
  ${date_value}=  Get Text  id=tdtpPosition_enquiryPeriod_startDate_Date
  ${time_value}=  Get Text  id=tePosition_enquiryPeriod_startDate_Time
  ${return_value}=  convert_date_to_iso  ${date_value}  ${time_value}
  [return]  ${return_value}

Отримати інформацію про enquiryPeriod.endDate
  ${date_value}=  Get Text  id=tdtpPosition_enquiryPeriod_endDate_Date
  ${time_value}=  Get Text  id=tePosition_enquiryPeriod_endDate_Time
  ${return_value}=  convert_date_to_iso  ${date_value}  ${time_value}
  [return]  ${return_value}

Отримати інформацію про items[0].deliveryAddress.countryName
  ${return_value}=  Отримати текст із поля і показати на сторінці  items[0].deliveryAddress.countryName
  [return]  ${return_value.split(', ')[0]}

Отримати інформацію про items[0].deliveryAddress.postalCode
  ${return_value}=  Отримати текст із поля і показати на сторінці  items[0].deliveryAddress.postalCode
  [return]  ${return_value.split(', ')[1]}

Отримати інформацію про items[0].deliveryAddress.region
  ${return_value}=  Отримати текст із поля і показати на сторінці  items[0].deliveryAddress.region
  [return]  ${return_value.split(', ')[2]}

Отримати інформацію про items[0].deliveryAddress.locality
  ${return_value}=  Отримати текст із поля і показати на сторінці  items[0].deliveryAddress.locality
  [return]  ${return_value.split(', ')[3]}

Отримати інформацію про items[0].deliveryAddress.streetAddress
  ${return_value}=  Отримати текст із поля і показати на сторінці  items[0].deliveryAddress.streetAddress
  [return]  ${return_value.split(', ')[4]}

Отримати інформацію про items[0].deliveryDate.endDate
  ${date_value}=  Отримати текст із поля і показати на сторінці  items[0].deliveryDate.endDate
  ${return_value}=  uub_service.convert_date  ${date_value}
  [return]  ${return_value}

Отримати інформацію про questions[${index}].title
  ${index}=  inc  ${index}
  Wait Until Element Is Visible  xpath=(//span[contains(@class, 'rec_qa_title')])[${index}]
  ${return_value}=  Get text  xpath=(//span[contains(@class, 'rec_qa_title')])[${index}]
  [return]  ${return_value}

Отримати інформацію про questions[${index}].description
  ${index}=  inc  ${index}
  Wait Until Element Is Visible  xpath=(//span[contains(@class, 'rec_qa_description')])[${index}]
  ${return_value}=  Get text  xpath=(//span[contains(@class, 'rec_qa_description')])[${index}]
  [return]  ${return_value}

Отримати інформацію про questions[${index}].answer
  ${index}=  inc  ${index}
  Wait Until Element Is Visible  xpath=(//span[contains(@class, 'rec_qa_answer')])[${index}]
  ${return_value}=  Get text  xpath=(//span[contains(@class, 'rec_qa_answer')])[${index}]
  [return]  ${return_value}

Отримати інформацію про questions[${index}].date
  ${index}=  inc  ${index}
  Wait Until Element Is Visible  xpath=(//span[contains(@class, 'rec_qa_date')])[${index}]
  ${return_value}=  Get text  xpath=(//span[contains(@class, 'rec_qa_date')])[${index}]
  ${return_value}=  convert_date_time_to_iso  ${return_value}
  [return]  ${return_value}

Отримати інформацію із запитання
  [Arguments]  ${username}  ${tender_uaid}  ${question_id}  ${field_name}
  uub.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  Перейти до сторінки запитань
  ${return_value}=  Run Keyword If  '${field_name}' == 'title'
  ...  Get Text  xpath=(//span[contains(@class, 'qa_title') and contains(@class, '${item_id}')])
  ...  ELSE IF  '${field_name}' == 'answer'  Get Text  xpath=(//span[contains(@class, 'qa_answer') and contains(@class, '${item_id}')])
  ...  ELSE  Get Text  xpath=(//span[contains(@class, 'qa_description') and contains(@class, '${item_id}')])
  [return]  ${return_value}

Задати запитання на тендер
  [Arguments]  ${username}  ${tender_uaid}  ${question}
  uub.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  Задати питання  ${username}  ${tender_uaid}  ${question}

Задати питання
  [Arguments]  ${username}  ${tender_uaid}  ${question}
  ${title}=  Get From Dictionary  ${question.data}  title
  ${description}=  Get From Dictionary  ${question.data}  description
  Wait Until Element Is Visible  xpath=(//*[@id='btn_question'])
  Click Element  id=btn_question
  Sleep  3
  Input text  id=e_title  ${title}
  Input text  id=e_description  ${description}
  Click Element  id=SendQuestion
  Wait Until Page Contains  Публікацію виконано

Задати запитання на предмет
  [Arguments]  ${username}  ${tender_uaid}  ${item_id}  ${question}
  uub.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  Wait Until Element Is Visible  xpath=(//*[@id='tPosition_status'])
  Click Element  xpath=(//span[contains(@class, 'bt_item_question') and contains(@class, '${item_id}')])
  Sleep  3
  Input text  id=e_title  ${question.data.title}
  Input text  id=e_description  ${question.data.description}
  Click Element  id=SendQuestion
  Wait Until Page Contains  Публікацію виконано

Відповісти на запитання
  [Arguments]  ${username}  ${tender_uaid}  ${answer_data}  ${item_id}
  uub.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  Перейти до сторінки запитань
  Wait Until Element Is Visible  xpath=(//span[contains(@class, 'btAnswer') and contains(@class, '${item_id}')])
  Click Element  xpath=(//span[contains(@class, 'btAnswer') and contains(@class, '${item_id}')])
  Input Text  id=e_answer  ${answer_data.data.answer}
  Click Element  id=SendAnswer
  Wait Until Page Contains  Публікацію виконано

Відповісти на питання
  [Arguments]  ${username}  ${tender_uaid}  ${question}  ${answer_data}
  ${answer}=  Get From Dictionary  ${answer_data.data}  answer
  Перейти до сторінки запитань
  Wait Until Element Is Visible  xpath=(//*[contains(@class, 'bt_addAnswer')])
  Click Element  css=.bt_addAnswer:first-child
  Input Text  id=e_answer  ${answer}
  Click Element  id=SendAnswer
  Wait Until Page Contains  Публікацію виконано

Подати цінову пропозицію
  [Arguments]  ${username}  ${tender_uaid}  ${bid_data}
  ${amount}=  get_str  ${bid_data.data.value.amount}
  ${is_qualified}=  is_qualified  ${bid_data}
  ${is_eligible}=  is_eligible  ${bid_data}
  uub.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  Wait Until Element Is Visible  xpath=(//*[@id='btnBid'])
  Click Element  id=btnBid
  Wait Until Element Is Visible  xpath=(//*[@id='bid_load_status'])
  Wait Until Element Is Visible          xpath=(//*[@id='eBid_price'])
  Input Text          id=eBid_price         ${amount}
  Run Keyword If  ${is_qualified}  Click Element  id=lcbBid_selfQualified
  Run Keyword If  ${is_eligible}  Click Element  id=lcbBid_selfEligible
  Click Element  id=btn_save
  Wait Until Element Is Visible  xpath=(//*[@id='btn_public'])
  Click Element  id=btn_public
  sleep  1
  ${resp}=  Get Value  id=eBid_price
  [return]  ${resp}

Скасувати цінову пропозицію
  [Arguments]  ${username}  ${tender_uaid}
  uub.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  Wait Until Element Is Visible  xpath=(//*[@id='btnShowBid'])
  Click Element  id=btnShowBid
  Wait Until Element Is Visible  xpath=(//*[@id='btn_delete'])
  Click Element  id=btn_delete

Отримати інформацію із пропозиції
  [Arguments]  ${username}  ${tender_uaid}  ${field}
  uub.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  Wait Until Element Is Visible  xpath=(//*[@id='btnShowBid'])
  Click Element  id=btnShowBid
  Wait Until Element Is Visible  xpath=(//*[@id='eBid_price'])
  ${value}=  Get Value  id=eBid_price
  ${value}=  Convert To Number  ${value}
  [Return]  ${value}

Змінити цінову пропозицію
  [Arguments]  ${username}  ${tender_uaid}  ${amount}  ${amount_value}
  ${amount}=  get_str  ${amount_value}
  uub.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  Wait Until Element Is Visible  xpath=(//*[@id='btnShowBid'])
  Click Element  id=btnShowBid
  Wait Until Element Is Visible  xpath=(//*[@id='eBid_price'])
  Input Text  id=eBid_price  ${amount}
  sleep  1
  Click Element  id=btn_public

Завантажити документ в ставку
  [Arguments]  ${username}  ${file}  ${bid_id}
  Wait Until Element Is Visible  xpath=(//*[@id='btnShowBid'])
  Click Element  id=btnShowBid
  Wait Until Element Is Visible  xpath=(//*[@id='btn_documents_add'])
  Click Element  id=btn_documents_add
  Choose File  xpath=(//*[@id='upload_form']/input[2])  ${file}
  Sleep  2
  Click Element  id=upload_button
  Wait Until Element Contains  id=tFileMessage  Файл завантажено
  Reload Page

Змінити документ в ставці
  [Arguments]  ${username}  ${tender_uaid}  ${filepath}  ${docid}
  Reload Page
  Wait Until Element Is Visible  xpath=(//*[@id='btn_documents_add'])
  Click Element  css=.bt_ReUpload:first-child
  Choose File  xpath=(//*[@id='upload_form']/input[2])  ${filepath}
  Sleep  2
  Click Element  id=upload_button
  Wait Until Element Contains  id=tFileMessage  Файл завантажено
  Reload Page

Завантажити фінансову ліцензію
  [Arguments]  ${username}  ${tender_uaid}  ${filepath}
  uub.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  Wait Until Element Is Visible  xpath=(//*[@id='btnShowBid'])
  Click Element  id=btnShowBid
  Wait Until Element Is Visible  xpath=(//*[@id='btn_documents_add'])
  Click Element  id=btn_documents_add
  Select From List By Value  id=slFile_documentType  financialLicense
  Choose File  xpath=(//*[@id='upload_form']/input[2])  ${filepath}
  Sleep  2
  Click Element  id=upload_button
  Wait Until Element Contains  id=tFileMessage  Файл завантажено
  Reload Page

Отримати інформацію про bids
  [Arguments]  ${username}  ${tender_uaid}
  Викликати для учасника  ${username}  Оновити сторінку з тендером  ${tender_uaid}
  Click Element  id=bids_ref

Отримати посилання на аукціон для глядача
  [Arguments]  ${username}  @{arguments}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  ${username}
  ...      ${ARGUMENTS[1]} ==  ${tender_uaid}
  ...      ${ARGUMENTS[2]} ==  ${lot_id} for multilot request in auction stage
  Switch Browser  ${BROWSER_ALIAS}
  Wait Until Element Is Visible  xpath=(//*[@id='aPosition_auctionUrl'])
  ${result} =  Get Text  id=aPosition_auctionUrl
  [return]  ${result}

Отримати посилання на аукціон для учасника
  [Arguments]  ${username}  @{arguments}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  ${username}
  ...      ${ARGUMENTS[1]} ==  ${tender_uaid}
  ...      ${ARGUMENTS[2]} ==  ${lot_id} for multilot request in auction stage
  Switch Browser  ${BROWSER_ALIAS}
  Wait Until Element Is Visible  xpath=(//*[@id='aPosition_auctionUrl'])
  ${result}=  Get Text  id=aPosition_auctionUrl
  [return]  ${result}

Завантажити документ в тендер з типом
  [Arguments]  ${username}  ${tender_uaid}  ${filepath}  ${doc_type}
  uub.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  uub.Завантажити документ до форми з типом  ${username}  ${tender_uaid}  ${filepath}  illustration

Завантажити документ до форми з типом
  [Arguments]  ${username}  ${tender_uaid}  ${filepath}  ${doc_type}
  Wait Until Element Is Visible  xpath=(//div[@id='pn_trd_doc_place']//*[@id='btn_documents_add'])
  Click Element  xpath=(//div[@id='pn_trd_doc_place']//*[@id='btn_documents_add'])
  Select From List By Value  id=slFile_documentType  ${doc_type}
  Choose File  xpath=(//*[@id='upload_form']/input[2])  ${filepath}
  Sleep  2
  Click Element  id=upload_button
  Wait Until Element Contains  id=tFileMessage  Файл завантажено

Завантажити ілюстрацію
  [Arguments]  ${username}  ${tender_uaid}  ${filepath}
  uub.Завантажити документ в тендер з типом  ${username}  ${tender_uaid}  ${filepath}  illustration

Додати Virtual Data Room
  [Arguments]  ${username}  ${tender_uaid}  ${vdr_url}
  uub.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  Wait Until Element Is Visible  xpath=(//*[@id='btn_documents_add'])
  Click Element  id=btn_documents_add
  Select From List By Value  id=slFile_documentType  virtualDataRoom
  Input text  id=eFile_url  ${vdr_url}
  Click Element  id=upload_button
  Wait Until Element Contains  id=tFileMessage  Файл завантажено

Додати публічний паспорт активу
  [Arguments]  ${username}  ${tender_uaid}  ${vdr_url}
  uub.Завантажити документ в тендер з типом  ${username}  ${tender_uaid}  ${filepath}  x_dgfPublicAssetCertificate

Додати офлайн документ
  [Arguments]  ${username}  ${tender_uaid}  ${accessDetails}
  uub.Завантажити документ в тендер з типом  ${username}  ${tender_uaid}  ${filepath}  x_dgfAssetFamiliarization

Отримати інформацію із документа по індексу
  [Arguments]  ${username}  ${tender_uaid}  ${document_index}  ${field}
  uub.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${doc_value}=  Get Text  xpath=(//*[@id='pn_documentsContent_']/table[${document_index + 1}]//span[contains(@class, 'documentType')])
  [return]  ${doc_value}

Отримати інформацію із документа
  [Arguments]  ${username}  ${tender_uaid}  ${doc_id}  ${field_name}
  ${doc_value}=  Run Keyword If  '${field_name}' == 'description'
  ...  Get Text  xpath=(//span[contains(@class, 'description') and contains(@class, '${doc_id}')])
  ...  ELSE  Get Text  xpath=(//a[contains(@class, 'doc_title') and contains(@class, '${doc_id}')])
  [Return]  ${doc_value}

Отримати кількість предметів в тендері
  [Arguments]  ${username}  ${tender_uaid}
  uub.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${return_value}=  Get Matching Xpath Count  xpath=(//div[starts-with(@id, 'pn_w_item')])
  [return]  ${return_value}

Додати предмет закупівлі
  [Arguments]  ${username}  ${tender_uaid}  ${item}
  uub.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${index}=  uub.Отримати кількість предметів в тендері  ${username}  ${tender_uaid}
  ${ItemAddButtonVisible}=  Page Should Contain Element  id=btn_items_add
  Run Keyword If  '${ItemAddButtonVisible}'=='PASS'  Run Keywords
  ...  Додати предмет  ${item}  ${index}
  ...  AND  Click Element  id=btnPublic
  ...  AND  Wait Until Page Contains  Публікацію виконано

Видалити предмет закупівлі
  [Arguments]  ${username}  ${tender_uaid}  ${item_id}
  uub.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${ItemAddButtonVisible}=  Page Should Contain Element  id=btn_items_add
  Run Keyword If  '${ItemAddButtonVisible}'=='PASS'  Run Keywords
  ...  Wait Until Element Is Visible  xpath=(//ul[contains(@class, 'bt_item_delete') and contains(@class, ${item_id})])
  ...  AND  Click Element  xpath=(//ul[contains(@class, 'bt_item_delete') and contains(@class, ${item_id})])
  ...  AND  Click Element  id=btnPublic
  ...  AND  Wait Until Page Contains  Публікацію виконано

Отримати кількість документів в тендері
  [Arguments]  ${username}  ${tender_uaid}
  uub.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${tender_doc_number}=  Get Matching Xpath Count  xpath=(//*[@id='pn_documentsContent_']/table)
  [Return]  ${tender_doc_number}

Отримати документ
  [Arguments]  ${username}  ${tender_uaid}  ${doc_id}
  Run Keyword If  ${SEARCH_MODE}=='assets'  uub.Пошук об’єкта МП по ідентифікатору  ${username}  ${tender_uaid}
  ...  ELSE IF  ${SEARCH_MODE}=='lots'  uub.Пошук лоту по ідентифікатору  ${username}  ${tender_uaid}
  ...  ELSE  uub.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  Click Element  xpath=(//a[contains(@class, 'doc_title') and contains(@class, '${doc_id}')])
  sleep  3
  ${file_name}=  Get Text  xpath=(//a[contains(@class, 'doc_title') and contains(@class, '${doc_id}')])
  ${url}=  Get Element Attribute  xpath=(//a[contains(@class, 'doc_title') and contains(@class, '${doc_id}')])@href
  download_file  ${url}  ${file_name.split('/')[-1]}  ${OUTPUT_DIR}
  [return]  ${file_name.split('/')[-1]}

Отримати дані із документу пропозиції
  [Arguments]  ${username}  ${tender_uaid}  ${bid_index}  ${document_index}  ${field}
  ${document_index}=  inc  ${document_index}
  ${result}=  Get Text  xpath=(//*[@id='pnAwardList']/div[last()]/div/div[1]/div/div/div[2]/table[${document_index}]//span[contains(@class, 'documentType')])
  [Return]  ${result}

Отримати кількість документів в ставці
  [Arguments]  ${username}  ${tender_uaid}  ${bid_index}
  uub.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${bid_doc_number}=  Get Matching Xpath Count  xpath=(//*[@id='pnAwardList']/div[last()]/div/div[1]/div/div/div[2]/table)
  [Return]  ${bid_doc_number}

Скасування рішення кваліфікаційної комісії
  [Arguments]  ${username}  ${tender_uaid}  ${award_index}
  ${award_index}=  inc  ${award_index}
  uub.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  Wait Until Element Is Visible  xpath=(//*[@id='pnAwardList']/div[${award_index}]//*[contains(@class, 'Cancel_button')])
  Sleep  1
  Click Element  xpath=(//*[@id='pnAwardList']/div[${award_index}]//*[contains(@class, 'Cancel_button')])

Підтвердити постачальника
  [Arguments]  ${username}  ${tender_uaid}  ${award_index}
  ${award_index}=  inc  ${award_index}
  uub.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  Wait Until Element Is Visible  xpath=(//*[@id='pnAwardList']/div[${award_index}]//*[contains(@class, 'award_button')])
  Sleep  1
  Click Element  xpath=(//*[@id='pnAwardList']/div[${award_index}]//*[contains(@class, 'award_button')])
  Wait Until Page Contains  Публікацію виконано

Дискваліфікувати постачальника
  [Arguments]  ${username}  ${tender_uaid}  ${award_index}  ${description}
  uub.Оновити сторінку з тендером  ${username}  ${tender_uaid}
  ${award_index}=  inc  ${award_index}
  Wait Until Element Is Visible  xpath=(//*[@id='pnAwardList']/div[${award_index}]//*[contains(@class, 'Reject_description')])
  Input text  xpath=(//*[@id='pnAwardList']/div[${award_index}]//*[contains(@class, 'Reject_description')])  ${description}
  Click Element  xpath=(//*[@id='pnAwardList']/div[${award_index}]//*[contains(@class, 'Reject_button')])
  Wait Until Page Contains  Публікацію виконано

Завантажити документ рішення кваліфікаційної комісії
  [Arguments]  ${username}  ${filepath}  ${tender_uaid}  ${award_index}
  ${award_index}=  inc  ${award_index}
  uub.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  Wait Until Element Is Visible  xpath=(//*[@id='tPosition_status'])
  Click Element  xpath=(//*[@id='pnAwardList']/div[${award_index}]//div[contains(@class, 'award_docs')]//span[contains(@class, 'add_document')])
  Choose File  xpath=(//*[@id='upload_form']/input[2])  ${filepath}
  Sleep  2
  Click Element  id=upload_button
  Wait Until Element Contains  id=tFileMessage  Файл завантажено
  Reload Page

Завантажити протокол аукціону
  [Arguments]  ${username}  ${tender_uaid}  ${filepath}  ${award_index}
  ${award_index}=  inc  ${award_index}
  uub.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  Wait Until Element Is Visible  xpath=(//*[@id='btnShowBid'])
  Click Element  id=btnShowBid
  Wait Until Element Is Visible  xpath=(//*[@id='btn_documents_add'])
  Click Element  id=btn_documents_add
  Select From List By Value  id=slFile_documentType  auctionProtocol
  Choose File  xpath=(//*[@id='upload_form']/input[2])  ${filepath}
  Sleep  2
  Click Element  id=upload_button
  Wait Until Element Contains  id=tFileMessage  Файл завантажено

Завантажити угоду до тендера
  [Arguments]  ${username}  ${tender_uaid}  ${contract_num}  ${filepath}
  uub.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  Wait Until Element Is Visible  xpath=(//div[contains(@id, 'pn_doc_contract_')][1]//span[contains(@class, 'add_document')])
  Click Element  xpath=(//div[contains(@id, 'pn_doc_contract_')][1]//span[contains(@class, 'add_document')])
  Select From List By Value  id=slFile_documentType  contractSigned
  Choose File  xpath=(//*[@id='upload_form']/input[2])  ${filepath}
  Sleep  2
  Click Element  id=upload_button
  Wait Until Element Contains  id=tFileMessage  Файл завантажено
  Reload Page

Підтвердити підписання контракту
  [Arguments]  ${username}  ${tender_uaid}  ${contract_num}
  ${file_path}  ${file_title}  ${file_content}=  create_fake_doc
  uub.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  Wait Until Element Is Visible  xpath=(//div[contains(@id, 'pn_control_contract')][1]//span[contains(@class, 'contract_register')])
  Click Element  xpath=(//div[contains(@id, 'pn_control_contract')][1]//span[contains(@class, 'contract_register')])
  Wait Until Page Contains  Публікацію виконано

Завантажити протокол аукціону в авард
  [Arguments]  ${username}  ${tender_uaid}  ${filepath}  ${award_index}
  ${award_index}=  inc  ${award_index}
  uub.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  Wait Until Element Is Visible  xpath=(//*[@id='tPosition_status'])
  Click Element  xpath=(//*[@id='pnAwardList']/div[${award_index}]//div[contains(@class, 'award_docs')]//span[contains(@class, 'add_document')])
  Select From List By Value  id=slFile_documentType  auctionProtocol
  Choose File  xpath=(//*[@id='upload_form']/input[2])  ${filepath}
  Sleep  2
  Click Element  id=upload_button
  Wait Until Element Contains  id=tFileMessage  Файл завантажено
  Reload Page

Підтвердити наявність протоколу аукціону
  [Arguments]  ${username}  ${tender_uaid}  ${award_index}
  ${award_index}=  inc  ${award_index}
  uub.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  Wait Until Element Is Visible  xpath=(//*[@id='tPosition_status'])
  Click Element  xpath=(//*[@id='pnAwardList']/div[${award_index}]//*[contains(@class, 'award_protocol_button')])
  Wait Until Page Contains  Публікацію виконано

Отримати інформацію про awards[${index}].status
  ${index}=  inc  ${index}
  Wait Until Element Is Visible  xpath=(//span[contains(@class, 'rec_award_status')])[${index}]
  ${return_value}=  Get text  xpath=(//span[contains(@class, 'rec_award_status')])[${index}]
  [return]  ${return_value}

Створити об'єкт МП
  [Arguments]  ${username}  ${tender_data}
  Set Global Variable  ${TENDER_INIT_DATA_LIST}  ${tender_data}
  Switch Browser  ${BROWSER_ALIAS}
  Wait Until Element Is Visible  xpath=(//a[contains(@class, 'tab-switch5')])  20
  Click Element  xpath=(//a[contains(@class, 'tab-switch5')])
  Wait Until Element Is Visible  id=btAddItem  20
  Click Element  id=btAddItem
  Wait Until Element Is Visible  id=ePosition_title  20
  ${title}=  Get From Dictionary  ${tender_data.data}  title
  ${description}=  Get From Dictionary  ${tender_data.data}  description
  ${decisionDate}=  Get From Dictionary   ${tender_data.data.decisions[0]}    decisionDate
  ${decisionDate}=  convert_ISO_DMY  ${decisionDate}
  ${decisionID}=  Get From Dictionary  ${tender_data.data.decisions[0]}    decisionID
  ${decisionTitle}=  Get From Dictionary  ${tender_data.data.decisions[0]}    title
  Input text  id=ePosition_title  ${title}
  Input text  id=ePosition_description  ${description}
  Input text  id=dtp_decision_0_decisionDate  ${decisionDate}
  Click Element  id=tPosition_statusText
  Input text  id=e_decision_0_title         ${decisionTitle}
  Input text  id=e_decision_0_decisionID    ${decisionID}
  ${org}=  Get From Dictionary  ${tender_data.data}  assetHolder
  ${org_name}=  Get From Dictionary  ${org}  name
  ${CP_name}  Get From Dictionary  ${org.contactPoint}  name
  ${CP_email}  Get From Dictionary  ${org.contactPoint}  email
  ${CP_faxNumber}  Get From Dictionary  ${org.contactPoint}  faxNumber
  ${CP_telephone}  Get From Dictionary  ${org.contactPoint}  telephone
  ${CP_url}  Get From Dictionary  ${org.contactPoint}  url
  ${org_identifier_id}  Get From Dictionary  ${org.identifier}  id
  ${org_identifier_legalName}  Get From Dictionary  ${org.identifier}  legalName
  ${org_address_countryName}  Get From Dictionary  ${org.address}  countryName
  ${org_address_region}  Get From Dictionary  ${org.address}  region
  ${org_address_locality}  Get From Dictionary  ${org.address}  locality
  ${org_address_postalCode}  Get From Dictionary  ${org.address}  postalCode
  ${org_address_streetAddress}  Get From Dictionary  ${org.address}  streetAddress
  Input text  id=ew_Org_0_CP_name  ${CP_name}
  Input text  id=ew_Org_0_CP_email  ${CP_email}
  Input text  id=ew_Org_0_CP_telephone  ${CP_telephone}
  Input text  id=ew_Org_0_CP_faxNumber  ${CP_faxNumber}
  Input text  id=ew_Org_0_CP_url  ${CP_url}
  Input text  id=ew_Org_0_PE_name  ${org_name}
  Input text  id=ew_Org_0_PE_identifier_id  ${org_identifier_id}
  Input text  id=ew_Org_0_PE_identifier_legalName  ${org_identifier_legalName}
  Input text  id=ew_Org_0_PE_address_countryName  ${org_address_countryName}
  Input text  id=ew_Org_0_PE_address_locality  ${org_address_locality}
  Input text  id=ew_Org_0_PE_address_postalCode  ${org_address_postalCode}
  Input text  id=ew_Org_0_PE_address_region  ${org_address_region}
  Input text  id=ew_Org_0_PE_address_streetAddress  ${org_address_streetAddress}
  ${org}=  Get From Dictionary  ${tender_data.data}  assetCustodian
  ${org_name}=  Get From Dictionary  ${org}  name
  ${CP_name}  Get From Dictionary  ${org.contactPoint}  name
  ${CP_email}  Get From Dictionary  ${org.contactPoint}  email
  ${CP_faxNumber}  Get From Dictionary  ${org.contactPoint}  faxNumber
  ${CP_telephone}  Get From Dictionary  ${org.contactPoint}  telephone
  ${CP_url}  Get From Dictionary  ${org.contactPoint}  url
  ${org_identifier_id}  Get From Dictionary  ${org.identifier}  id
  ${org_identifier_legalName}  Get From Dictionary  ${org.identifier}  legalName
  ${org_address_countryName}  Get From Dictionary  ${org.address}  countryName
  ${org_address_region}  Get From Dictionary  ${org.address}  region
  ${org_address_locality}  Get From Dictionary  ${org.address}  locality
  ${org_address_postalCode}  Get From Dictionary  ${org.address}  postalCode
  ${org_address_streetAddress}  Get From Dictionary  ${org.address}  streetAddress
  Input text  id=ew_Org_1_CP_name  ${CP_name}
  Input text  id=ew_Org_1_CP_email  ${CP_email}
  Input text  id=ew_Org_1_CP_telephone  ${CP_telephone}
  Input text  id=ew_Org_1_CP_faxNumber  ${CP_faxNumber}
  Input text  id=ew_Org_1_CP_url  ${CP_url}
  Input text  id=ew_Org_1_PE_name  ${org_name}
  Input text  id=ew_Org_1_PE_identifier_id  ${org_identifier_id}
  Input text  id=ew_Org_1_PE_identifier_legalName  ${org_identifier_legalName}
  Input text  id=ew_Org_1_PE_address_countryName  ${org_address_countryName}
  Input text  id=ew_Org_1_PE_address_locality  ${org_address_locality}
  Input text  id=ew_Org_1_PE_address_postalCode  ${org_address_postalCode}
  Input text  id=ew_Org_1_PE_address_region  ${org_address_region}
  Input text  id=ew_Org_1_PE_address_streetAddress  ${org_address_streetAddress}
  ${items}=  Get From Dictionary  ${tender_data.data}  items
  ${Items_length}=  Get Length  ${items}
  :FOR  ${index}  IN RANGE  ${Items_length}
  \	 Click Element  id=btn_items_add
  \  Додати актив МП  ${items[${index}]}  ${index}
  Click Element  id=btnSend
  Wait Until Page Contains  Збереження виконано
  Click Element  id=btnPublic
  Wait Until Page Contains  Публікацію виконано
  ${tender_id}=  Get Text  id=tPosition_tenderID
  log to console  ${tender_id}
  [return]  ${tender_id}

Додати актив МП
  [Arguments]  ${item}  ${index}
  Wait Until Element Is Visible  id=ew_item_${index}_description
  Input text  id=ew_item_${index}_description  ${item.description}
  ${quantity}=  get_str  ${item.quantity}
  Input text  id=ew_item_${index}_quantity  ${quantity}
  Select From List By Value  id=slw_item_${index}_unit_code  ${item.unit.code}
  Select From List By Value  id=slw_item_${index}_classification_scheme  ${item.classification.scheme}
  Input text  id=ew_item_${index}_classification_id  ${item.classification.id}
  Wait Until Element Is Visible  xpath=(//ul[contains(@class, 'ui-autocomplete')]//li//a)
  Click Element  xpath=(//ul[contains(@class, 'ui-autocomplete')]//li//a)
  Input text  id=ew_item_${index}_address_countryName  ${item.address.countryName}
  Input text  id=ew_item_${index}_address_postalCode  ${item.address.postalCode}
  Input text  id=ew_item_${index}_address_region  ${item.address.region}
  Input text  id=ew_item_${index}_address_locality  ${item.address.locality}
  Input text  id=ew_item_${index}_address_streetAddress  ${item.address.streetAddress}
  Select From List By Value  id=slw_item_${index}_registrationDetails_status  ${item.registrationDetails.status}
  ${has_registrationID}=  Run Keyword And Return Status  Dictionary Should Contain Key  ${item.registrationDetails}  registrationID
  Run Keyword If  ${has_registrationID}
  ...  Input text  id=ew_item_${index}_registrationDetails_registrationID  ${item.registrationDetails.registrationID}
  ${registrationDate}  Set Variable  ${EMPTY}
  ${has_registrationDate}=  Run Keyword And Return Status  Dictionary Should Contain Key  ${item.registrationDetails}  registrationDate
  Run Keyword If  ${has_registrationDate}
  ...  ${registrationDate}=  convert_ISO_DMY  ${item.registrationDetails.registrationDate}
  Run Keyword If  ${has_registrationDate}
  ...  Input text  id=ew_item_${index}_registrationDetails_registrationDate  ${registrationDate}
  Run Keyword If  ${has_registrationDate}
  ...  Click Element  id=tPosition_statusText

Пошук об’єкта МП по ідентифікатору
  [Arguments]  ${username}  ${asset_uaid}
  Switch Browser  ${BROWSER_ALIAS}
  Go to  ${USERS.users['${username}'].default_page}
  Set Global Variable   ${SEARCH_MODE}   'assets'
  Wait Until Element Is Visible  xpath=(//a[contains(@class, 'tab-switch5')])
  Click Element  xpath=(//a[contains(@class, 'tab-switch5')])
  Wait Until Element Contains  id=records_shown  Y
  Input Text  id=ew_fv_0_value  ${asset_uaid}
  Click Element  id=btnFilter
  Wait Until Element Contains  id=records_shown  Y
  Wait Until Element Is Visible  xpath=(//a[contains(@class, 'record_title')])
  Click Element   xpath=(//a[contains(@class, 'record_title')])
  Wait Until Element Is Visible  xpath=(//*[@id='tPosition_status'])

Отримати інформацію із об'єкта МП
  [Arguments]  ${username}  ${asset_uaid}  ${fieldname}
  ${return_value}=  Run Keyword  uub.Отримати інформацію про ${fieldname}
  [return]  ${return_value}

Отримати інформацію з активу об'єкта МП
  [Arguments]  ${username}  ${asset_uaid}  ${item_id}  ${field_name}
  ${return_value}=   Run KeyWord   uub.Отримати інформацію з поля предмету  ${username}  ${asset_uaid}  ${item_id}  ${field_name}
  [Return]  ${return_value}

Внести зміни в об'єкт МП
  [Arguments]  ${username}  ${asset_uaid}  ${fieldname}  ${fieldvalue}
  uub.Пошук об’єкта МП по ідентифікатору  ${username}  ${asset_uaid}
  Run KeyWord  uub.Внести зміни в об'єкт МП поле  ${fieldname}  ${fieldvalue}
  Click Element  id=btnPublic

Внести зміни в об'єкт МП поле 
  [Arguments]  ${fieldname}  ${fieldvalue}
  uub.Внести зміни до елементу за шляхом  //*[@name = '${fieldname}']  ${fieldname}  ${fieldvalue}

Внести зміни в актив об'єкта МП
  [Arguments]  ${username}  ${item_id}  ${asset_uaid}  ${fieldname}  ${fieldvalue}
  uub.Пошук об’єкта МП по ідентифікатору  ${username}  ${asset_uaid}
  Run KeyWord  uub.Внести зміни до елементу за шляхом  //div[starts-with(@id, 'pn_w_item') and contains(@class, '${item_id}')]//*[@name= '${fieldname}']  ${fieldname}  ${fieldvalue}
  Click Element  id=btnPublic

Додати актив до об'єкта МП
  [Arguments]  ${username}  ${asset_uaid}  ${item}
  uub.Пошук об’єкта МП по ідентифікатору  ${username}  ${asset_uaid}
  ${item_count}=  Get Matching Xpath Count  xpath=(//div[starts-with(@id, 'pn_w_item')])
  ${item_count}=  Convert To Integer  ${item_count}
  Click Element  id=btn_items_add
  Run KeyWord  Додати актив МП  ${item}  ${item_count - 1}
  Click Element  id=btnPublic

Отримати кількість активів в об'єкті МП
  [Arguments]  ${username}  ${asset_uaid}
  uub.Пошук об’єкта МП по ідентифікатору  ${username}  ${asset_uaid}
  ${return_value}=  Get Matching Xpath Count  xpath=(//div[starts-with(@id, 'pn_w_item')])
  [return]  ${return_value}

Завантажити документ в об'єкт МП з типом
  [Arguments]  ${username}  ${tender_uaid}  ${filepath}  ${doc_type}
  uub.Пошук об’єкта МП по ідентифікатору  ${username}  ${tender_uaid}
  uub.Завантажити документ до форми з типом  ${username}  ${tender_uaid}  ${filepath}  ${doc_type}

Завантажити ілюстрацію в об'єкт МП
  [Arguments]  ${username}  ${asset_uaid}  ${filepath}
  uub.Завантажити документ в об'єкт МП з типом  ${username}  ${asset_uaid}  ${filepath}  illustration

Завантажити документ для видалення об'єкта МП
  [Arguments]  ${username}  ${asset_uaid}  ${filepath}
  uub.Завантажити документ в об'єкт МП з типом  ${username}  ${asset_uaid}  ${filepath}  cancellationDetails

Видалити об'єкт МП
  [Arguments]  ${username}  ${asset_uaid}
  uub.Пошук об’єкта МП по ідентифікатору  ${username}  ${asset_uaid}
  Click Element  id=btnCancel

Створити лот
  [Arguments]    ${username}  ${tender_data}  ${asset_uaid}
  uub.Пошук об’єкта МП по ідентифікатору  ${username}  ${asset_uaid}
  Click Element   id=btnCreateLot
  Input text  id=e_сreateLot_decisionID    ${tender_data.data.decisions[0].decisionID}
  ${decisionDate}=  convert_ISO_DMY  ${tender_data.data.decisions[0].decisionDate}
  Input text  id=dtp_сreateLot_decisionDate  ${decisionDate}
  Click Element  id=e_сreateLot_decisionID
  Sleep  1
  Click Element  id=dg_createLot_send
  Wait Until Element Is Visible  tPosition_assetID
  ${tender_id}=  Get Text  id=tPosition_tenderID
  log to console  ${tender_id}
  [return]  ${tender_id}

Пошук лоту по ідентифікатору
  [Arguments]  ${username}  ${lot_uaid}
  Switch Browser  ${BROWSER_ALIAS}
  Set Global Variable   ${SEARCH_MODE}   'lots'
  Go to  ${USERS.users['${username}'].default_page}
  Wait Until Element Is Visible  xpath=(//a[contains(@class, 'tab-switch6')])
  Click Element  xpath=(//a[contains(@class, 'tab-switch6')])
  Wait Until Element Contains  id=records_shown  Y
  Input Text  id=ew_fv_0_value  ${lot_uaid}
  Click Element  id=btnFilter
  Wait Until Element Contains  id=records_shown  Y
  Wait Until Element Is Visible  xpath=(//a[contains(@class, 'record_title')])
  Click Element   xpath=(//a[contains(@class, 'record_title')])
  Wait Until Element Is Visible  xpath=(//*[@id='tPosition_status'])

Додати умови проведення аукціону
  [Arguments]  ${username}  ${auction}  ${index}  ${lot_uaid}
  Run KeyWord  Додати умови проведення аукціону номер ${index}  ${username}  ${lot_uaid}  ${auction}

Додати умови проведення аукціону номер 0
  [Arguments]  ${username}  ${lot_uaid}  ${auction}
  uub.Пошук лоту по ідентифікатору  ${username}  ${lot_uaid}
  Внести дату та час  _auction_0_auctionPeriod_startDate  ${auction.auctionPeriod.startDate}
  ${value_amount}=  Convert To String  ${auction.value.amount}
  Input Text  id=e_auction_0_value_amount  ${value_amount}
  ${value_valueaddedtaxincluded}=  Convert To String  ${auction.value.valueAddedTaxIncluded}
  UnSelect Checkbox  id=cb_auction_0_value_valueAddedTaxIncluded
  Run Keyword If  ${value_valueaddedtaxincluded} == 'True'  Select Checkbox  id=cb_auction_0_value_valueAddedTaxIncluded
  ${minimalStep}=  Convert To String  ${auction.minimalStep.amount}
  Input Text  id=e_auction_0_minimalStep_amount  ${minimalStep}
  ${guarantee_amount}=  Convert To String  ${auction.guarantee.amount}
  Input Text  id=e_auction_0_guarantee_amount  ${guarantee_amount}
  ${registrationFee}=  Convert To String  ${auction.registrationFee.amount}
  Input Text  id=e_auction_0_registrationFee_amount  ${registrationFee}
  Input Text  id=e_auction_0_bankAccount_bankName  ${auction.bankAccount.bankName}
  Input Text  id=e_auction_0_bankAccount_description  ${auction.bankAccount.description}
  Встановити параметри рахунку  ${auction.bankAccount.accountIdentification[0]}

Встановити параметри рахунку 
  [Arguments]  ${accountIdentification}
  Run Keyword If  '${accountIdentification.scheme}' == 'UA-EDR'  Input Text  id=e_auction_0_bankAccount_code  ${accountIdentification.id}
  Run Keyword If  '${accountIdentification.scheme}' == 'UA-MFO'  Input Text  id=e_auction_0_bankAccount_mfo  ${accountIdentification.id}
  Run Keyword If  '${accountIdentification.scheme}' == 'accountNumber'  Input Text  id=e_auction_0_bankAccount_accountNumber  ${accountIdentification.id}

Додати умови проведення аукціону номер 1
  [Arguments]  ${username}  ${lot_uaid}  ${auction}
  ${tenderingDuration}=  convert_iso8601Duration  ${auction.tenderingDuration}
  Input Text  id=e_auction_1_tenderingDuration  ${tenderingDuration}
  Click Element  id=btnPublic

Оновити сторінку з об'єктом МП
  [Arguments]  ${username}  ${lot_uaid}
  uub.Пошук об’єкта МП по ідентифікатору  ${username}  ${lot_uaid}

Отримати інформацію із лоту
  [Arguments]  ${username}  ${tender_uaid}  ${fieldname}
  ${return_value}=  Run Keyword  uub.Отримати інформацію про ${fieldname}
  [return]  ${return_value}

Отримати інформацію з активу лоту
  [Arguments]  ${username}  ${lot_uaid}  ${item_id}  ${field_name}
  ${return_value}=   Run KeyWord   uub.Отримати інформацію з поля предмету  ${username}  ${lot_uaid}  ${item_id}  ${field_name}
  [Return]  ${return_value}

Завантажити документ в лот з типом
  [Arguments]  ${username}  ${tender_uaid}  ${filepath}  ${doc_type}
  uub.Пошук лоту по ідентифікатору  ${username}  ${tender_uaid}
  uub.Завантажити документ до форми з типом  ${username}  ${tender_uaid}  ${filepath}  ${doc_type}

Завантажити документ в умови проведення аукціону
  [Arguments]  ${username}  ${tender_uaid}  ${filepath}  ${doc_type}  ${auction_index}
  uub.Пошук лоту по ідентифікатору  ${username}  ${tender_uaid}
  Wait Until Element Is Visible  xpath=(//div[@id='pn_auction_${auction_index}_doc_place']//*[@id='btn_documents_add'])
  Click Element  id=btn_documents_add
  Select From List By Value  id=slFile_documentType  ${doc_type}
  Choose File  xpath=(//*[@id='upload_form']/input[2])  ${filepath}
  Sleep  2
  Click Element  id=upload_button
  Wait Until Element Contains  id=tFileMessage  Файл завантажено

Завантажити ілюстрацію в лот
  [Arguments]  ${username}  ${tender_uaid}  ${filepath}
  uub.Завантажити документ в лот з типом  ${username}  ${tender_uaid}  ${filepath}  illustration

Завантажити документ для видалення лоту
  [Arguments]  ${username}  ${tender_uaid}  ${filepath}
  uub.Завантажити документ в лот з типом  ${username}  ${tender_uaid}  ${filepath}  cancellationDetails

Видалити лот
  [Arguments]  ${username}  ${tender_uaid}
  uub.Пошук лоту по ідентифікатору  ${username}  ${tender_uaid}
  Click Element  id=btnCancel

Оновити сторінку з лотом
  [Arguments]  ${username}  ${tender_uaid}
  uub.Пошук лоту по ідентифікатору  ${username}  ${tender_uaid}

Внести зміни в лот
  [Arguments]  ${username}  ${tender_uaid}  ${fieldname}  ${fieldvalue}
  uub.Пошук лоту по ідентифікатору  ${username}  ${tender_uaid}
  Run KeyWord  uub.Внести зміни в лот поле  ${fieldname}  ${fieldvalue}
  Click Element  id=btnPublic

Внести зміни в лот поле 
  [Arguments]  ${fieldname}  ${fieldvalue}
  uub.Внести зміни до елементу за шляхом  //*[@name = '${fieldname}']  ${fieldname}  ${fieldvalue}

Внести зміни в актив лоту
  [Arguments]  ${username}  ${item_id}  ${tender_uaid}  ${fieldname}  ${fieldvalue}
  uub.Пошук лоту по ідентифікатору  ${username}  ${tender_uaid}
  Run KeyWord  uub.Внести зміни до елементу за шляхом  //div[starts-with(@id, 'pn_w_item') and contains(@class, '${item_id}')]//*[@name= '${fieldname}']  ${fieldname}  ${fieldvalue}
  Click Element  id=btnPublic

Внести зміни в умови проведення аукціону
  [Arguments]  ${username}  ${tender_uaid}  ${fieldname}  ${fieldvalue}  ${item_id}
  uub.Пошук лоту по ідентифікатору  ${username}  ${tender_uaid}
  Run Keyword If  '${fieldname}' == 'auctionPeriod.startDate'  uub.Внести дату та час  _auction_${item_id}_auctionPeriod_startDate  ${fieldvalue}
  ...  ELSE  uub.Внести зміни до елементу за шляхом  //*[@name= 'auctions[${item_id}].${fieldname}']  ${fieldname}  ${fieldvalue}
  Click Element  id=btnPublic

Отримати інформацію про ${fieldname}
  ${fieldname_end}=	 Remove String Using Regexp  ${fieldname}	.*].
  ${return_value}=  Отримати інформацію з елементу за шляхом //*[@name = '${fieldname}']
  ${return_value}=  Run Keyword If  '${fieldname_end}' == 'tenderAttempts'  Convert To Integer  ${return_value.replace(' ', '').replace(',', '.')}
  ...  ELSE IF  '${fieldname_end}' == 'value.amount'  Convert To Number  ${return_value.replace(' ', '').replace(',', '.')}
  ...  ELSE IF  '${fieldname_end}' == 'registrationFee.amount'  Convert To Number  ${return_value.replace(' ', '').replace(',', '.')}
  ...  ELSE IF  '${fieldname_end}' == 'guarantee.amount'  Convert To Number  ${return_value.replace(' ', '').replace(',', '.')}
  ...  ELSE IF  '${fieldname_end}' == 'minimalStep.amount'  Convert To Number  ${return_value.replace(' ', '').replace(',', '.')}
  ...  ELSE IF  '${fieldname_end}' == 'dutchSteps'  Convert To Integer  ${return_value.replace(' ', '').replace(',', '.')}
  ...  ELSE  Set Variable  ${return_value}
  [Return]  ${return_value}

Отримати інформацію з елементу за шляхом ${elementname}
  ${return_value}=  Get Value  xpath=(//div[@id='page_content']${elementname})
  ${status}=   Run Keyword And Return Status   Should Be Equal   ${return_value}   ${None}
  ${return_value}=  Run Keyword If  ${status}  Get Text  xpath=(//div[@id='page_content']${elementname})
  ...  ELSE  Set Variable  ${return_value}
  [return]  ${return_value}

Внести зміни до елементу за шляхом 
  [Arguments]  ${elementname}  ${fieldname}  ${fieldvalue}
  ${fieldvalue}=  Run Keyword If  '${field_name}' == 'value.amount'  get_str  ${fieldvalue}
  ...  ELSE IF  '${field_name}' == 'minimalStep.amount'  get_str  ${fieldvalue}
  ...  ELSE IF  '${field_name}' == 'registrationFee.amount'  get_str  ${fieldvalue}
  ...  ELSE IF  '${field_name}' == 'guarantee.amount'  get_str  ${fieldvalue}
  ...  ELSE IF  '${field_name}' == 'quantity'  get_str  ${fieldvalue}
  ...  ELSE IF  '${field_name}' == 'auctionPeriod.startDate'  convert_ISO_DMY  ${fieldvalue}
  ...  ELSE  Set Variable  ${fieldvalue}
  Input text  xpath=(//div[@id='page_content']${elementname})  ${fieldvalue}
  Click Element  id=btnPublic

Внести дату
  [Arguments]  ${prefix}  ${_value}
  ${_Date}=  convert_ISO_DMY  ${_value}
  Input Text  id=dtp${prefix}_Date  ${_Date}
  Input Text  id=e${prefix}_Time  ${_Time}

Внести дату та час
  [Arguments]  ${prefix}  ${_value}
  ${_Date}=  convert_ISO_DMY  ${_value}
  ${_Time}=  convert_ISO_HM  ${_value}
  Input Text  id=dtp${prefix}_Date  ${_Date}
  Input Text  id=e${prefix}_Time  ${_Time}

