#!/usr/bin/ruby
queue_list = `rabbitmqctl list_queues`.split("\n") 
queue_list.pop
queue_list.shift

queues = Hash.new
queue_list.each do |queue|
  queue = queue.strip.split(/\s+/).collect(&:strip)
  queue_stat = queue.pop
  queue_name = queue.pop
  queues[queue_name] = queue_stat
end

queues.each do |key, value|
  value.each do |value, description|
    puts "queues.#{key} #{value}"
  end
end
