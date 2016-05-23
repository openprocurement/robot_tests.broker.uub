# -*- coding: utf-8 -*-
import dateutil.parser
from datetime import datetime
from robot.libraries.BuiltIn import BuiltIn

def get_webdriver():
    se2lib = BuiltIn().get_library_instance('Selenium2Library')
    return se2lib._current_browser()

def is_checked(locator):
    driver = get_webdriver()
    return driver.find_element_by_id(locator).is_selected()

def get_budget(initial_tender_data):
    return str(initial_tender_data.data.value.amount)

def get_step_rate(initial_tender_data):
    return str(initial_tender_data.data.minimalStep.amount)

def get_quantity(item):
    return str(item.quantity)

def get_latitude(item):
    return str(item.deliveryLocation.latitude)

def get_longitude(item):
    return str(item.deliveryLocation.longitude)

def get_tender_dates_uub(initial_tender_data, key):
    enquiry_period = initial_tender_data.data.enquiryPeriod
    start_de = dateutil.parser.parse(enquiry_period['startDate'])
    end_de = dateutil.parser.parse(enquiry_period['endDate'])
    tender_period = initial_tender_data.data.tenderPeriod
    start_dt = dateutil.parser.parse(tender_period['startDate'])
    end_dt = dateutil.parser.parse(tender_period['endDate'])
    data = {
        'StartPeriodDate': start_de.strftime("%d.%m.%Y"),
        'StartPeriodTime': start_de.strftime("%H:%M"),
        'EndPeriodDate': end_de.strftime("%d.%m.%Y"),
        'EndPeriodTime': end_de.strftime("%H:%M"),
        'StartDate': start_dt.strftime("%d.%m.%Y"),
        'StartTime': start_dt.strftime("%H:%M"),
        'EndDate': end_dt.strftime("%d.%m.%Y"),
        'EndTime': end_dt.strftime("%H:%M"),
    }
    return data.get(key, '')

def get_all_uub_dates(initial_tender_data, key):
    tender_period = initial_tender_data.data.tenderPeriod
    start_dt = dateutil.parser.parse(tender_period['startDate'])
    end_dt = dateutil.parser.parse(tender_period['endDate'])
    data = {
        'EndPeriod': start_dt.strftime("%d.%m.%Y %H:%M"),
        'StartDate': start_dt.strftime("%d.%m.%Y %H:%M"),
        'EndDate': end_dt.strftime("%d.%m.%Y %H:%M"),
    }
    return data.get(key, '')


def get_delivery_date_uub(item):
    delivery_end_date = item['deliveryDate']['endDate']
    endDate = dateutil.parser.parse(delivery_end_date)
    return endDate.strftime("%d.%m.%Y")


def return_delivery_endDate(initial_tender_data, input_date):
    init_delivery_end_date = initial_tender_data.data['items'][0]['deliveryDate']['endDate']
    if input_date in init_delivery_end_date:
        return init_delivery_end_date
    else:
        return input_date


def convert_delivery_date_uub(isodate):
    return datetime.strptime(isodate, '%d.%m.%Y').date().isoformat()


def convert_uub_date_to_iso(v_date, v_time):
    full_value = v_date+" "+v_time
    value_iso = datetime.strptime(full_value, "%d.%m.%Y %H:%M").isoformat()
    return value_iso

def get_scheme_uub(f_value):
    return f_value.split(' ')[1]


def convert_date_to_uub_tender_enddate(isodate):
    second_date = isodate.split(' - ')[1]
    second_iso = datetime.strptime(second_date, "%d.%m.%y %H:%M").isoformat()
    return second_iso


def procuringEntity_name_uub(initial_tender_data):
    initial_tender_data.data.procuringEntity['name'] = u"Test_company_from_Prozorro"
    return initial_tender_data


def convert_uub_string_to_common_string(string):
    return {
        u"Украина": u"Україна",
        u"Киевская область": u"м. Київ",
        u"килограммы": u"кілограм",
        u"кг.": u"кілограм",
        u"грн.": u"UAH",
        u" з ПДВ": True,
        u"Картонки": u"Картонні коробки",
    }.get(string, string)
