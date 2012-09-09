#!/usr/bin/ruby
queue_list = `netstat -us| awk '/packet receive|packets received/ {print $1}'`.split("\n") 
puts "udp.errors #{queue_list.pop}"
puts "udp.received #{queue_list.pop}"
