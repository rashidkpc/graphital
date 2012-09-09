#!/usr/bin/ruby

require 'socket'

metrics = [ 'curr_connections', 'curr_items','cmd_get','cmd_set','get_hits','get_misses','evictions' ]

socket = TCPSocket.open('localhost', '11211')
socket.send("stats\r\n", 0)

statistics = []
loop do
  data = socket.recv(4096)
  if !data || data.length == 0
    break
  end
  lines = data.strip.split(/\n/).collect(&:strip)
  lines.each do |metric|
    metric = metric.strip.split(/\s+/).collect(&:strip)
    if metrics.include?(metric[1])
      puts "#{metric[1]} #{metric[2]}"
    end
  end
  statistics << data
  if statistics.join.split(/\n/)[-1] =~ /END/
    break
  end
end
