# -*- coding: utf-8 -*-
import dateutil.parser
from datetime import datetime
from robot.libraries.BuiltIn import BuiltIn
import urllib
import json
import copy

def get_webdriver():
    se2lib = BuiltIn().get_library_instance('Selenium2Library')
    return se2lib._current_browser()
   
def get_str(value):
    return str(value)

def convert_ISO_Y(isodate):
    return dateutil.parser.parse(isodate).strftime("%Y")

def convert_ISO_DMY(isodate):
    return dateutil.parser.parse(isodate).strftime("%d.%m.%Y")

def inc(value):
    return int(value) + 1
    
def is_checked(locator):
    driver = get_webdriver()
    return driver.find_element_by_id(locator).is_selected()

def convert_date_to_iso(v_date, v_time):
    full_value = v_date+" "+v_time
    date_obj = datetime.strptime(full_value, "%d.%m.%Y %H:%M")
    time_zone = pytz.timezone('Europe/Kiev')
    localized_date = time_zone.localize(date_obj)
    return localized_date.strftime("%Y-%m-%dT%H:%M:%S.%f%z")

def convert_date_time_to_iso(v_date_time):
    date_obj = datetime.strptime(v_date_time, "%d.%m.%Y %H:%M")
    time_zone = pytz.timezone('Europe/Kiev')
    localized_date = time_zone.localize(date_obj)
    return localized_date.strftime("%Y-%m-%dT%H:%M:%S.%f%z")

def get_enquiryPeriod(initial_tender_data, key):
    enquiry_period = initial_tender_data.data.enquiryPeriod
    start = dateutil.parser.parse(enquiry_period['startDate'])
    end = dateutil.parser.parse(enquiry_period['endDate'])
    
    data = {
        'StartDate': start.strftime("%d.%m.%Y"),
        'StartTime': start.strftime("%H:%M"),
        'EndDate': end.strftime("%d.%m.%Y"),
        'EndTime': end.strftime("%H:%M"),
    }
    return data.get(key, '')

def get_tenderPeriod(initial_tender_data, key):
    enquiry_period = initial_tender_data.data.tenderPeriod
    start = dateutil.parser.parse(enquiry_period['startDate'])
    end = dateutil.parser.parse(enquiry_period['endDate'])
    
    data = {
        'StartDate': start.strftime("%d.%m.%Y"),
        'StartTime': start.strftime("%H:%M"),
        'EndDate': end.strftime("%d.%m.%Y"),
        'EndTime': end.strftime("%H:%M"),
    }
    return data.get(key, '')

def convert_ISO_DMY(isodate):
    return dateutil.parser.parse(isodate).strftime("%d.%m.%Y")

def convert_ISO_HM(isodate):
    return dateutil.parser.parse(isodate).strftime("%H:%M")

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

def convert_date_time_uub_to_iso(v_date_time):
    value_iso = datetime.strptime(v_date_time, "%d.%m.%Y %H:%M").isoformat()
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

def adapt_owner(tender_data):
    tender_data['data']['procuringEntity']['name'] = u'u_Owner'
    tender_data['data']['procuringEntity']['identifier']['id'] = u'00000701'
    tender_data['data']['procuringEntity']['identifier']['legalName'] = u'u_Owner'
    tender_data['data']['procuringEntity']['address']['postalCode'] = u'11223'
    tender_data['data']['procuringEntity']['address']['region'] = u'Івано-Франківська область'
    tender_data['data']['procuringEntity']['address']['locality'] = u'м.Київ'
    tender_data['data']['procuringEntity']['address']['streetAddress'] = u'Вулиця111'
    return tender_data
    
def download_file(url, file_name, output_dir):
    urllib.urlretrieve(url, ('{}/{}'.format(output_dir, file_name)))
    
def json_load(json_str):
    return json.loads(json_str)
    
def copy_object(x):
    return copy.deepcopy(x)    

def get_change_field_name(change_dict, index):
    return list(change_dict.keys())[index]
def get_change_field_value(change_dict):
    return list(change_dict.values())[index]    