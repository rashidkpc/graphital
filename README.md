# Graphital 
<rashidkpc #logstash irc.freenode.net>

Graphital is a very (~50 lines) simple ruby daemon for shipping system vitals 
to Graphite. It uses a graphital.d directory and simply runs everything in it.
Several examples are included, but its easy to write your own in your language
of choice. If you write something particularly useful, please do share. Scripts
should output in the format:  
  metric #

For example, to track cpu % you might create a file called
graphital.d/cpu.rb and it might output (to stdout):  
  user 18  
  idle 80  
  iowait 2  

Graphital will prepend the $PREFIX you set in graphital.conf (by default this 
includes `hostname`.chomp to prepend the hostname) and the name of the script
before the first '.'. The above example might create a metric like 
hostname1.cpu.user. Scripts must complete in less than your specified $INTERVAL
(60s by default) or they will be terminated.  

## Requirements

ruby >= 1.8.7 (probably?)  
daemons gem (or bundler, which will just install the daemons gem)  

## Installation
Install:  
  git clone https://github.com/rashidkpc/graphital.git /opt/graphital  
  cd /opt/graphital  
  gem install daemons  

Configure:  
Set your Graphite server in graphital.conf:  
  $HOST = 'graphite.example.com'  

Run:  
This will invoke graphital.rb and put it into the background.  
  ruby /opt/graphital/daemon.rb start  
