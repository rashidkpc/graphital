#!/usr/bin/ruby

begin
  load '/etc/graphital.conf'
rescue LoadError
  begin
    load '/opt/graphital/graphital.conf'
  rescue LoadError
    load '/opt/graphital/graphital.conf.eg'
  end
end

require 'socket'
require 'timeout'

def vitals
  vitals = Array.new
  Dir.foreach("#{$PATH}") do |item|
    next if item == '.' or item == '..'
    vitals << Thread.new{ Thread.current[:output] = run_vital(item) }
  end
  vitals
end

def run_vital(item)
  vital = nil
  name = item.split('.').first
  status = Timeout::timeout($INTERVAL) {
    vital = `#{$PATH}/#{item}`.split("\n")
    vital = name + "." + vital.join("\n#{name}.")
  }
  vital
end

def vital_output(host,port)
  socket = TCPSocket.open(host,port)
  time = Time.now.to_i.to_s
  output = ''
  vitals.each do |vital|
    vital.join
    vital[:output].split("\n").each do |vital|
      output += "#{$PREFIX}.#{vital} #{time}\n"
    end
  end
  puts output
  socket.print(output)
  socket.close
end

loop {
  output = Thread.new{vital_output($HOST,$PORT)} 
  sleep $INTERVAL;
}

