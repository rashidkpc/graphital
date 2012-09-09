#!/usr/bin/ruby
free = `sar -n DEV 1 5|grep Average`.split("\n") 
descriptions  = free[0].split(/\s+|\|/).collect{|x| x.strip.sub("/s","")}
descriptions.shift(2)
free.shift

interfaces = Hash.new
free.each do |interface|
  interface = interface.strip.split(/\s+/).collect(&:strip)
  interface.shift
  ifname = interface.shift
  interfaces[ifname] = interface.collect(&:to_f).zip(descriptions)
end

interfaces.each do |key, value|
  value.each do |value, description|
    puts "#{key}.#{description} #{value}"
  end
end
