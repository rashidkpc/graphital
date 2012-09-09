#!/usr/bin/ruby
descriptions = [ '1min', '5min', '15min' ]
#loads = %x{'free'}.split('\s+').last.split(',').collect(&:strip).
#  zip(descriptions)

free = %x{'free'}.split("\n")

descriptions  = free[0].split(/\s+/).collect(&:strip)
mem           = free[1].split(/\s+/).collect(&:strip)
swap          = free[3].split(/\s+/).collect(&:strip)
buffers       = free[2].split(/\s+/).collect(&:strip)

descriptions.shift
mem.shift
swap.shift
buffers.shift
buffers.shift

mem = mem.zip(descriptions)

3.times do
  descriptions.pop
end

swap = swap.zip(descriptions)

descriptions.shift

buffers = buffers.zip(descriptions)

mem.each do |metric,description|
  puts "mem.#{description} #{metric}"
end

buffers.each do |metric,description|
  puts "cache.#{description} #{metric}"
end

swap.each do |metric,description|
  puts "swap.#{description} #{metric}"
end
