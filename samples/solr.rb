#!/usr/bin/ruby

require 'rubygems'
require 'net/http'
require 'uri'
require 'nokogiri'

cores =[
  'locations',
  'stuff',
  'things'
]

def get_html_content(requested_url)
  url = URI.parse(requested_url)
  full_path = "#{url.path}?#{url.query}"
  the_request = Net::HTTP::Get.new(full_path)

  the_response = Net::HTTP.start(url.host, url.port) { |http|
    http.request(the_request)
  }

  raise "Response was not 200, response was #{the_response.code}" if the_response.code != "200"
  return the_response.body
end

cores.each do |core|
  s = get_html_content("http://localhost:8983/solr/#{core}/admin/stats.jsp")
  @doc = Nokogiri::XML(s)
  @entries = @doc.xpath('//QUERYHANDLER/entry/name[contains(text(), "standard")]/..')

  @entries.each do |i|
    totalRequests = i.css('stats stat[@name = "requests"]').text.strip
    totalTime = i.css('stats stat[@name = "totalTime"]').text.strip
    puts "#{core}.totalRequests #{totalRequests}"
    puts "#{core}.totalTime #{totalTime}"
  end
end
