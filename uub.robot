*** Settings ***
Library   Selenium2Screenshots
Library   String
Library   DateTime
Library   Selenium2Library
Library   Collections
Library   uub_service.py

*** Variables ***
${locator.edit.description}                                     id=ePosition_description
${locator.title}                                                id=tePosition_title
${locator.description}                                          id=tePosition_description
${locator.minimalStep.amount}                                   id=tePosition_minimalStep_amount
${locator.value.amount}                                         id=tePosition_value_amount
${locator.value.valueAddedTaxIncluded}                          id=cbPosition_value_valueAddedTaxIncluded
${locator.value.currency}                                       id=tslPosition_value_currency
${locator.enquiryPeriod.startDate}                              id=tdtpPosition_enquiryPeriod_startDate_Date
${locator.enquiryPeriod.endDate}                                id=tdtpPosition_enquiryPeriod_endDate_Date
${locator.tenderPeriod.startDate}                               id=tdtpPosition_tenderPeriod_startDate_Date
${locator.tenderPeriod.endDate}                                 id=tdtpPosition_tenderPeriod_endDate_Date
${locator.tenderId}                                             id=tPosition_tenderID
${locator.procuringEntity.name}                                 id=tw_Org_0_PE_identifier_legalName


${locator.items[0].quantity}                                    id=tew_item_0_quantity
${locator.items[0].description}                                 id=tew_item_0_description
${locator.items[0].deliveryLocation.latitude}                   id=tew_item_0_deliveryLocation_latitude
${locator.items[0].deliveryLocation.longitude}                  id=tew_item_0_deliveryLocation_longitude
${locator.items[0].unit.code}                                   id=tw_item_0_unit_code
${locator.items[0].unit.name}                                   id=tslw_item_0_unit_code
${locator.items[0].deliveryAddress.postalCode}                  id=tew_item_0_deliveryAddress_postalCode
${locator.items[0].deliveryAddress.countryName}                 id=tew_item_0_deliveryAddress_countryName
${locator.items[0].deliveryAddress.region}                      id=tew_item_0_deliveryAddress_region
${locator.items[0].deliveryAddress.locality}                    id=tew_item_0_deliveryAddress_locality
${locator.items[0].deliveryAddress.streetAddress}               id=tew_item_0_deliveryAddress_streetAddress
${locator.items[0].deliveryDate.endDate}                        id=tdtpw_item_0_deliveryDate_endDate_Date
${locator.items[0].classification.scheme}                       id=nw_item_0_classification_id
${locator.items[0].classification.id}                           id=tew_item_0_classification_id
${locator.items[0].classification.description}                  id=tw_item_0_classification_description
${locator.items[0].additionalClassifications[0].scheme}         id=nw_item_0_additionalClassifications_id
${locator.items[0].additionalClassifications[0].id}             id=tew_item_0_additionalClassifications_id
${locator.items[0].additionalClassifications[0].description}    id=tw_item_0_additionalClassifications_description

${locator.questions[0].title}                                   css=.qa_title
${locator.questions[0].description}                             css=.qa_description
${locator.questions[0].date}                                    css=.qa_question_date
${locator.questions[0].answer}                                  css=.qa_answer


*** Keywords ***
Підготувати клієнт для користувача
  [Arguments]     @{ARGUMENTS}
  [Documentation]  Відкрити брaвзер, створити обєкт api wrapper, тощо
  Open Browser  ${USERS.users['${ARGUMENTS[0]}'].homepage}  ${USERS.users['${ARGUMENTS[0]}'].browser}  alias=${ARGUMENTS[0]}
  Set Window Size       @{USERS.users['${ARGUMENTS[0]}'].size}
  Set Window Position   @{USERS.users['${ARGUMENTS[0]}'].position}
  Run Keyword If   '${ARGUMENTS[0]}' != 'UUB_Viewer'   Login   ${ARGUMENTS[0]}

Login
  [Arguments]  @{ARGUMENTS}
  Input text      id=eLogin          ${USERS.users['${ARGUMENTS[0]}'].login}
  Click Button    id=btnLogin
  Sleep   2

Змінити користувача
  [Arguments]  @{ARGUMENTS}
  Go to   ${USERS.users['${ARGUMENTS[0]}'].homepage}
  Sleep   2
  Input text      id=eLogin          ${USERS.users['${ARGUMENTS[0]}'].login}
  Click Button    id=btnLogin
  Sleep   2

Створити тендер
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  tender_data

    Set Global Variable      ${TENDER_INIT_DATA_LIST}         ${ARGUMENTS[1]}

    ${title}=                Get From Dictionary         ${ARGUMENTS[1].data}             title
    ${description}=          Get From Dictionary         ${ARGUMENTS[1].data}             description
    ${items}=                Get From Dictionary         ${ARGUMENTS[1].data}             items
    ${budget}=               get_budget                  ${ARGUMENTS[1]}
    ${step_rate}=            get_step_rate               ${ARGUMENTS[1]}

    ${currency}=                 Get From Dictionary         ${ARGUMENTS[1].data.value}       currency
    ${valueAddedTaxIncluded}=    Get From Dictionary         ${ARGUMENTS[1].data.value}       valueAddedTaxIncluded

    ${start_period_enquiry_date}=  get_tender_dates_uub          ${ARGUMENTS[1]}           StartPeriodDate
    ${start_period_enquiry_time}=  get_tender_dates_uub          ${ARGUMENTS[1]}           StartPeriodTime
    ${end_period_enquiry_date}=  get_tender_dates_uub          ${ARGUMENTS[1]}           EndPeriodDate
    ${end_period_enquiry_time}=  get_tender_dates_uub          ${ARGUMENTS[1]}           EndPeriodTime
    ${start_tender_date}=        get_tender_dates_uub          ${ARGUMENTS[1]}           StartDate
    ${start_tender_time}=        get_tender_dates_uub          ${ARGUMENTS[1]}           StartTime
    ${end_tender_date}=          get_tender_dates_uub          ${ARGUMENTS[1]}           EndDate
    ${end_tender_time}=          get_tender_dates_uub          ${ARGUMENTS[1]}           EndTime

    ${item0}=                Get From List               ${items}                         0
    ${descr_lot}=            Get From Dictionary         ${item0}                         description
    ${unit}=                 Get From Dictionary         ${items[0].unit}                 code
    ${cpv_id}=               Get From Dictionary         ${items[0].classification}       id
    ${dkpp_id}=              Get From Dictionary         ${items[0].additionalClassifications[0]}      id
    ${countryName}=          Get From Dictionary         ${items[0].deliveryAddress}      countryName
    ${postalCode}=           Get From Dictionary         ${items[0].deliveryAddress}      postalCode
    ${region}=                   Get From Dictionary         ${items[0].deliveryAddress}      region
    ${locality}=             Get From Dictionary         ${items[0].deliveryAddress}      locality
    ${streetAddress}=        Get From Dictionary         ${items[0].deliveryAddress}      streetAddress
    ${latitude}=             get_latitude                ${items[0]}
    ${longitude}=            get_longitude               ${items[0]}
    ${quantity}=             get_quantity                ${items[0]}
    ${delivery_end}=             get_delivery_date_uub      ${items[0]}


    Selenium2Library.Switch Browser    ${ARGUMENTS[0]}
    Wait Until Page Contains Element     id=btAddTender    20
    Click Element                        id=btAddTender
    Wait Until Page Contains Element     id=ePosition_title       20
    Input text                           id=ePosition_title                    ${title}
    Input text                           id=ePosition_description          ${description}
    Input text             id=ePosition_value_amount                       ${budget}
    Click Element          id=cbPosition_value_valueAddedTaxIncluded

    Input text             id=dtpPosition_enquiryPeriod_startDate_Date          ${start_period_enquiry_date}
    Input text             id=ePosition_enquiryPeriod_startDate_Time          ${start_period_enquiry_time}

    Input text             id=dtpPosition_enquiryPeriod_endDate_Date          ${end_period_enquiry_date}
    Input text             id=ePosition_enquiryPeriod_endDate_Time          ${end_period_enquiry_time}
    Input text             id=dtpPosition_tenderPeriod_startDate_Date          ${start_tender_date}
    Input text             id=ePosition_tenderPeriod_startDate_Time          ${start_tender_time}
    Input text             id=dtpPosition_tenderPeriod_endDate_Date          ${end_tender_date}
    Input text             id=ePosition_tenderPeriod_endDate_Time          ${end_tender_time}
    input text             id=ePosition_minimalStep_amount                         ${step_rate}

    Click Element          id=btn_items_add
     Sleep   1
    Input text        id=ew_item_0_description               ${descr_lot}
    Input text        id=ew_item_0_quantity                  ${quantity}
    Select From List By Value        id=slw_item_0_unit_code                ${unit}
    Input text        id=ew_item_0_classification_id         ${cpv_id}
     Sleep   1
    Click Element     xpath=(//*[@id='ui-id-1']//li//a)
    Input text        id=ew_item_0_additionalClassifications_id                      ${dkpp_id}
     Sleep   1
    Click Element     xpath=(//*[@id='ui-id-2']//li//a)

    Input text        id=dtpw_item_0_deliveryDate_endDate_Date          ${delivery_end}

    Input text        id=ew_item_0_deliveryAddress_countryName       ${countryName}
    Input text        id=ew_item_0_deliveryAddress_postalCode       ${postalCode}
    Input text        id=ew_item_0_deliveryAddress_region          ${region}
    Input text        id=ew_item_0_deliveryAddress_locality          ${locality}
    Input text        id=ew_item_0_deliveryAddress_streetAddress    ${streetAddress}
    Input text        id=ew_item_0_deliveryLocation_latitude          ${latitude}
    Input text        id=ew_item_0_deliveryLocation_longitude         ${longitude}
    Click Element      id=btnSend
    Sleep   3
    Wait Until Element Contains  id=ValidateTips      Збереження виконано         10
    Click Element      id=btnPublic
    Wait Until Element Contains  id=ValidateTips      Публікацію виконано         10

    ${tender_id}=     Get Text        id=tPosition_tenderID
    ${TENDER}=        Get Text        id=tPosition_tenderID
    log to console      ${TENDER}
    [return]    ${TENDER}

Завантажити документ
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  ${filepath}
  ...      ${ARGUMENTS[2]} ==  ${TENDER}
  Go to   ${USERS.users['${ARGUMENTS[0]}'].default_page}
  Click Element    id=btFilterNumber
  Sleep  1
  Input Text        id=ew_fv_0_value   ${ARGUMENTS[2]}
  Click Element     id=btnFilter
  Sleep  2
  CLICK ELEMENT    xpath=(//a[contains(@class, 'tender_rec')])
  sleep  3
  CLICK ELEMENT     id=btn_documents_add
  Choose File       xpath=(//*[@id='diagFileUpload']/table/tbody/tr/td[2]/div/form/input[2])   ${ARGUMENTS[1]}
  Sleep   2
  Submit Form       upload_form
  Capture Page Screenshot

Пошук тендера за ідентифікатором
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  ${TENDER}
  Selenium2Library.Switch Browser    ${ARGUMENTS[0]}
  Go to   ${USERS.users['${ARGUMENTS[0]}'].default_page}
  Click Element    id=btFilterNumber
  Sleep  1
  Input Text      id=ew_fv_0_value   ${ARGUMENTS[1]}
  Click Element    id=btnFilter
  Sleep  2
  CLICK ELEMENT    xpath=(//a[contains(@class, 'tender_rec')])
  sleep  2
  Capture Page Screenshot

Перейти до сторінки запитань
  Wait Until Page Contains Element   id=questions_ref
  Click Element     id=questions_ref
  Sleep   1

Задати питання
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  tenderUaId
  ...      ${ARGUMENTS[2]} ==  questionId
  ${title}=        Get From Dictionary  ${ARGUMENTS[2].data}  title
  ${description}=  Get From Dictionary  ${ARGUMENTS[2].data}  description
  Перейти до сторінки запитань
  Click Element     id=btn_add
  Sleep   1
  Input text          id=e_title                 ${title}
  Input text          id=e_description           ${description}
  Click Element     id=SendQuestion
  Sleep  3
  Capture Page Screenshot

Оновити сторінку з тендером
    [Arguments]    @{ARGUMENTS}
    [Documentation]
    ...      ${ARGUMENTS[0]} = username
    ...      ${ARGUMENTS[1]} = ${TENDER_UAID}
    Selenium2Library.Switch Browser    ${ARGUMENTS[0]}
    Пошук тендера за ідентифікатором    ${ARGUMENTS[0]}    ${ARGUMENTS[1]}

Отримати інформацію із тендера
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  fieldname
  ${return_value}=  run keyword  Отримати інформацію про ${ARGUMENTS[1]}
  [return]  ${return_value}

Отримати тест із поля і показати на сторінці
  [Arguments]   ${fieldname}
  ${return_value}=   Get Text  ${locator.${fieldname}}
  [return]  ${return_value}

Отримати інформацію про title
  ${return_value}=   Отримати тест із поля і показати на сторінці   title
  [return]  ${return_value}

Отримати інформацію про description
  ${return_value}=   Отримати тест із поля і показати на сторінці   description
  [return]  ${return_value}


Отримати інформацію про value.amount
  ${return_value}=   Отримати тест із поля і показати на сторінці  value.amount
  ${return_value}=   Convert To Number   ${return_value.replace(' ', '').replace(',', '.')}
  [return]  ${return_value}

Отримати інформацію про minimalStep.amount
  ${return_value}=   Отримати тест із поля і показати на сторінці   minimalStep.amount
  ${return_value}=    convert to number    ${return_value.replace(',', '.')[:5]}
  [return]   ${return_value}

Внести зміни в тендер
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} =  username
  ...      ${ARGUMENTS[1]} =  ${TENDER_UAID}
  ...      ${ARGUMENTS[2]} ==  fieldname
  ...      ${ARGUMENTS[3]} ==  fieldvalue
  Викликати для учасника  ${ARGUMENTS[0]}  Оновити сторінку з тендером  ${ARGUMENTS[1]}
  Wait Until Page Contains Element   ${locator.edit.${ARGUMENTS[2]}}   5
  Input Text       ${locator.edit.${ARGUMENTS[2]}}   ${ARGUMENTS[3]}
  Click Element      id=btnPublic
  Wait Until Element Contains  id=ValidateTips      Публікацію виконано        5
  Викликати для учасника  ${ARGUMENTS[0]}  Оновити сторінку з тендером  ${ARGUMENTS[1]}
  ${result_field}=  Get Value   ${locator.edit.${ARGUMENTS[2]}}
  Should Be Equal   ${result_field}   ${ARGUMENTS[3]}


Отримати інформацію про items[0].quantity
  ${return_value}=   Отримати тест із поля і показати на сторінці   items[0].quantity
  ${return_value}=    Convert To Number   ${return_value.split(' ')[0]}
  [return]  ${return_value}

Отримати інформацію про items[0].unit.code
  ${return_value}=   Отримати тест із поля і показати на сторінці   items[0].unit.code
  [return]  ${return_value}

Отримати інформацію про items[0].unit.name
  ${return_value}=   Отримати тест із поля і показати на сторінці   items[0].unit.name
  [return]   ${return_value}

Отримати інформацію про value.currency
  ${return_value}=   Get Selected List Value        slPosition_value_currency
  [return]  ${return_value}

Отримати інформацію про value.valueAddedTaxIncluded
  ${return_value}=   is_checked                     cbPosition_value_valueAddedTaxIncluded
  [return]  ${return_value}

Отримати інформацію про tenderId
  ${return_value}=   Отримати тест із поля і показати на сторінці   tenderId
  [return]  ${return_value}

Отримати інформацію про procuringEntity.name
  ${return_value}=   Отримати тест із поля і показати на сторінці   procuringEntity.name
   Fail  Поле заповнюється за реєстраційною карткою Учасника

Отримати інформацію про items[0].deliveryLocation.latitude
  ${return_value}=   Отримати тест із поля і показати на сторінці   items[0].deliveryLocation.latitude
  ${return_value}=   convert to number   ${return_value.replace(' ', '').replace(',', '.')}
  [return]  ${return_value}

Отримати інформацію про items[0].deliveryLocation.longitude
  ${return_value}=   Отримати тест із поля і показати на сторінці   items[0].deliveryLocation.longitude
  ${return_value}=   convert to number    ${return_value.replace(' ', '').replace(',', '.')}
  [return]  ${return_value}

Отримати інформацію про tenderPeriod.startDate
  ${date_value}=   Get Text  tdtpPosition_tenderPeriod_startDate_Date
  ${time_value}=   Get Text  tePosition_tenderPeriod_startDate_Time
  ${return_value}=    convert_uub_date_to_iso    ${date_value}   ${time_value}
  [return]    ${return_value}

Отримати інформацію про tenderPeriod.endDate
  ${date_value}=   Get Text  tdtpPosition_tenderPeriod_endDate_Date
  ${time_value}=   Get Text  tePosition_tenderPeriod_endDate_Time
  ${return_value}=    convert_uub_date_to_iso    ${date_value}   ${time_value}
  [return]    ${return_value}

Отримати інформацію про enquiryPeriod.startDate
  ${date_value}=   Get Text  tdtpPosition_enquiryPeriod_startDate_Date
  ${time_value}=   Get Text  tePosition_enquiryPeriod_startDate_Time
  ${return_value}=    convert_uub_date_to_iso    ${date_value}   ${time_value}
  [return]  ${return_value}

Отримати інформацію про enquiryPeriod.endDate
  ${date_value}=   Get Text  tdtpPosition_enquiryPeriod_endDate_Date
  ${time_value}=   Get Text  tePosition_enquiryPeriod_endDate_Time
  ${return_value}=    convert_uub_date_to_iso    ${date_value}   ${time_value}
  [return]  ${return_value}

Отримати інформацію про items[0].description
  ${return_value}=   Отримати тест із поля і показати на сторінці   items[0].description
  [return]  ${return_value}

Отримати інформацію про items[0].classification.id
  ${return_value}=   Отримати тест із поля і показати на сторінці  items[0].classification.id
  [return]  ${return_value}

Отримати інформацію про items[0].classification.scheme
  ${return_value}=   Отримати тест із поля і показати на сторінці  items[0].classification.scheme
  ${return_value}=   get_scheme_uub  ${return_value}
  [return]  ${return_value}

Отримати інформацію про items[0].classification.description
  ${return_value}=   Отримати тест із поля і показати на сторінці  items[0].classification.description
  [return]  ${return_value}

Отримати інформацію про items[0].additionalClassifications[0].id
  ${return_value}=   Отримати тест із поля і показати на сторінці  items[0].additionalClassifications[0].id
  [return]  ${return_value}

Отримати інформацію про items[0].additionalClassifications[0].scheme
  ${return_value}=   Отримати тест із поля і показати на сторінці  items[0].additionalClassifications[0].scheme
  ${return_value}=   get_scheme_uub  ${return_value}
  [return]  ${return_value}

Отримати інформацію про items[0].additionalClassifications[0].description
  ${return_value}=   Отримати тест із поля і показати на сторінці  items[0].additionalClassifications[0].description
  [return]  ${return_value}

Отримати інформацію про items[0].deliveryAddress.countryName
  ${return_value}=   Отримати тест із поля і показати на сторінці  items[0].deliveryAddress.countryName
  [return]   ${return_value}

Отримати інформацію про items[0].deliveryAddress.postalCode
  ${return_value}=   Отримати тест із поля і показати на сторінці  items[0].deliveryAddress.postalCode
  [return]   ${return_value}

Отримати інформацію про items[0].deliveryAddress.region
  ${return_value}=   Отримати тест із поля і показати на сторінці  items[0].deliveryAddress.region
  [return]   ${return_value}

Отримати інформацію про items[0].deliveryAddress.locality
  ${return_value}=   Отримати тест із поля і показати на сторінці  items[0].deliveryAddress.locality
  [return]   ${return_value}

Отримати інформацію про items[0].deliveryAddress.streetAddress
  ${return_value}=   Отримати тест із поля і показати на сторінці  items[0].deliveryAddress.streetAddress
  [return]   ${return_value}

Отримати інформацію про items[0].deliveryDate.endDate
  ${return_value}=   Отримати тест із поля і показати на сторінці  items[0].deliveryDate.endDate
  [return]  ${return_value}

Отримати інформацію про questions[0].title
  Click Element                       id=questions_ref
  sleep   2
  ${return_value}=   Отримати тест із поля і показати на сторінці   questions[0].title
  [return]  ${return_value}

Отримати інформацію про questions[0].description
  ${return_value}=   Отримати тест із поля і показати на сторінці   questions[0].description
  [return]  ${return_value}

Отримати інформацію про questions[0].date
  ${return_value}=   Отримати тест із поля і показати на сторінці   questions[0].date
  [return]  ${return_value}

Отримати інформацію про questions[0].answer
  ${return_value}=   Отримати тест із поля і показати на сторінці   questions[0].answer
  [return]  ${return_value}

Відповісти на питання
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} = username
  ...      ${ARGUMENTS[1]} = ${TENDER_UAID}
  ...      ${ARGUMENTS[2]} = 0
  ...      ${ARGUMENTS[3]} = answer_data
  ${answer}=     Get From Dictionary  ${ARGUMENTS[3].data}  answer
  Викликати для учасника  ${ARGUMENTS[0]}  Оновити сторінку з тендером  ${ARGUMENTS[1]}
  Перейти до сторінки запитань
  Wait Until Page Contains Element      css=.bt_addAnswer
  Click Element                         css=.bt_addAnswer:first-child
  Input Text                            id=e_answer        ${answer}
  Click Element                         id=SendAnswer
  sleep   1
  Capture Page Screenshot

Подати цінову пропозицію
    [Arguments]  @{ARGUMENTS}
    [Documentation]
    ...    ${ARGUMENTS[0]} ==  username
    ...    ${ARGUMENTS[1]} ==  tenderId
    ...    ${ARGUMENTS[2]} ==  ${test_bid_data}
    ${amount}=    Get From Dictionary     ${ARGUMENTS[2].data.value}    amount
    Викликати для учасника  ${ARGUMENTS[0]}  Оновити сторінку з тендером  ${ARGUMENTS[1]}
    Wait Until Page Contains Element          id=btnBid    5
    Click Element       id=btnBid
    Sleep   1
    Wait Until Page Contains Element          id=eBid_price    5
    Input Text          id=eBid_price         ${amount}
    Capture Page Screenshot
    Click Element       id=btn_public
    sleep   1
    ${resp}=    Get Value      id=eBid_price
    [return]    ${resp}

Скасувати цінову пропозицію
    [Arguments]  @{ARGUMENTS}
    [Documentation]
    ...    ${ARGUMENTS[0]} ==  username
    ...    ${ARGUMENTS[1]} ==  tenderId
    Викликати для учасника  ${ARGUMENTS[0]}  Оновити сторінку з тендером  ${ARGUMENTS[1]}
    Wait Until Page Contains Element   id=btnShowBid    5
    Click Element       id=btnShowBid
    Sleep   1
    Wait Until Page Contains Element   id=btn_delete    5
    Click Element       id=btn_delete

Змінити цінову пропозицію
    [Arguments]  @{ARGUMENTS}
    [Documentation]
    ...    ${ARGUMENTS[0]} ==  username
    ...    ${ARGUMENTS[1]} ==  tenderId
    ...    ${ARGUMENTS[2]} ==  amount
    ...    ${ARGUMENTS[3]} ==  amount.value
    Викликати для учасника  ${ARGUMENTS[0]}  Оновити сторінку з тендером  ${ARGUMENTS[1]}
    Wait Until Page Contains Element   id=btnShowBid    5
    Click Element       id=btnShowBid
    Sleep   1
    Wait Until Page Contains Element          id=eBid_price    5
    Input Text              id=eBid_price         ${ARGUMENTS[3]}
    sleep   1
    Click Element       id=btn_public

Завантажити документ в ставку
    [Arguments]  @{ARGUMENTS}
    [Documentation]
    ...    ${ARGUMENTS[1]} ==  file
    ...    ${ARGUMENTS[2]} ==  tenderId
    Викликати для учасника  ${ARGUMENTS[0]}  Оновити сторінку з тендером  ${ARGUMENTS[2]}
    Wait Until Page Contains Element   id=btnShowBid    5
    Click Element       id=btnShowBid
    Sleep   1
    Wait Until Page Contains Element          id=btn_documents_add    5
    CLICK ELEMENT     id=btn_documents_add
    Choose File       xpath=(//*[@id='diagFileUpload']/table/tbody/tr/td[2]/div/form/input[2])   ${ARGUMENTS[1]}
    Sleep   2
    Submit Form       upload_form

Змінити документ в ставці
    [Arguments]  @{ARGUMENTS}
    [Documentation]
    ...    ${ARGUMENTS[0]} ==  username
    ...    ${ARGUMENTS[1]} ==  file
    ...    ${ARGUMENTS[2]} ==  tenderId
    Викликати для учасника  ${ARGUMENTS[0]}  Оновити сторінку з тендером  ${ARGUMENTS[2]}
    Wait Until Page Contains Element   id=btnShowBid    5
    Click Element       id=btnShowBid
    Sleep   1
    CLICK ELEMENT     css=.bt_ReUpload:first-child
    Choose File       xpath=(//*[@id='diagFileUpload']/table/tbody/tr/td[2]/div/form/input[2])   ${ARGUMENTS[1]}
    Sleep   2
    Submit Form       upload_form

Отримати інформацію про bids
    [Arguments]  @{ARGUMENTS}
    Викликати для учасника  ${ARGUMENTS[0]}  Оновити сторінку з тендером  ${ARGUMENTS[1]}
    Click Element                       id=bids_ref

Отримати посилання на аукціон для глядача
    [Arguments]  @{ARGUMENTS}
    Selenium2Library.Switch Browser       ${ARGUMENTS[0]}
    Викликати для учасника  ${ARGUMENTS[0]}  Оновити сторінку з тендером  ${ARGUMENTS[1]}
    Sleep   60
    reload page
    ${result} =    get text    id=aPosition_auctionUrl
    [return]   ${result}

Отримати посилання на аукціон для учасника
    [Arguments]  @{ARGUMENTS}
    Selenium2Library.Switch Browser       ${ARGUMENTS[0]}
    Викликати для учасника  ${ARGUMENTS[0]}  Оновити сторінку з тендером  ${ARGUMENTS[1]}
    Sleep   60
    reload page
    ${result}=       get text  id=aPosition_auctionUrl
    [return]   ${result}
