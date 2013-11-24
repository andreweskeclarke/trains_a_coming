require 'sinatra'
require "sinatra/json"
require 'sinatra/reloader'
require 'json'
require 'nokogiri'
require 'net/http'
require 'time'

CTA_HOST = "http://lapi.transitchicago.com/api/1.0/ttarrivals.aspx"
CTA_TIME_FORMAT = "%Y%m%d %T"
CTA_XML_ARRIVAL_TIME = "//eta/arrT"

get '/' do
  cta_response = request_train_arrival_time
  arrival_time = parse_utc_time_from cta_response
  time_diff = arrival_time - Time.now.utc
  json({:time_to_next_train => time_diff})
end

def request_train_arrival_time
  uri = URI.parse(CTA_HOST)
  params = {:key => "219f56e6f90949bd88db9fa28aa57d37",
            :stpid => "30272",
            :max => 1}
  uri.query = URI.encode_www_form(params)
  Net::HTTP.get(uri)
end

def parse_utc_time_from response
  response_xml = Nokogiri::XML.parse response
  arrival_time_text = response_xml.xpath(CTA_XML_ARRIVAL_TIME).text
  convert_cta_time_to_utc Time.strptime(arrival_time_text + " +0000", CTA_TIME_FORMAT + " %z")
end

def convert_cta_time_to_utc time
  cta_hours_since_epoch = (time.to_f / (60 * 60)).floor
  utc_hours_since_epoch = (Time.now.utc.to_f / (60 * 60)).floor
  hours_offset = utc_hours_since_epoch - cta_hours_since_epoch
  time + (hours_offset * 60 * 60)
end
