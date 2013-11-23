require 'sinatra'
require "sinatra/json"
require 'sinatra/reloader'
require 'json'
require 'nokogiri'
require 'net/http'
require 'time'

get '/' do
  uri = URI.parse("http://lapi.transitchicago.com/api/1.0/ttarrivals.aspx")
  params = {:key => "219f56e6f90949bd88db9fa28aa57d37",
            :stpid => "30272",
            :max => 1}
  uri.query = URI.encode_www_form(params)
  response = Net::HTTP.get(uri)
  response_xml = Nokogiri::XML.parse response
  arrival_time_element = response_xml.xpath "//eta/arrT"
  arrival_time = Time.strptime(arrival_time_element.text, "%Y%m%d %T")
  time_diff = arrival_time - Time.now
  json({:time_to_next_train => time_diff})
end
