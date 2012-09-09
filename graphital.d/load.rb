#!/usr/bin/ruby
descriptions = [ '1min', '5min', '15min' ]
loads = %x{'uptime'}.split(':').last.split(',').collect(&:strip).
  zip(descriptions)

loads.each do |load, description|
  puts "#{description} #{load}"
end
