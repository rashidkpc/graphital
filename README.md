# Graphital 

#### This probably still works, but I don't use it anymore, so I don't update it anymore, hence it has been archived.

Find Rashid Khan ([rashidkpc](irc://irc.freenode.net/rashidkpc,isnick))
in [#logstash](irc://irc.freenode.net/logstash).

Graphital is a very simple (~50 lines) ruby daemon for shipping system vitals 
to Graphite. It uses a `graphital.d` directory and simply runs everything in it.
Several examples are included (most require the `sar` utility from the `sysstat`
package), but its easy to write your own in your language of choice. If you
write something particularly useful, please do share. Scripts should output in 
the format:  

    metric #

For example, to track cpu % you might create a file called
`graphital.d/cpu.rb` and it might output (to stdout):  

    user 18  
    idle 80  
    iowait 2  

Graphital will prepend the `$PREFIX` you set in `graphital.conf` (by default
this includes `%x(hostname).chomp` to prepend the hostname) and the name of the
script before the first `.`. The above example might create a metric like 
`hostname1.cpu.user`. Scripts must complete in less than your specified
`$INTERVAL` (60s by default) or they will be terminated.  

## Requirements

* Ruby >= 1.8.7 (probably?)  
* `daemons` gem (or an alternate daemonization strategy)  

## Use

### Install

    git clone https://github.com/rashidkpc/graphital.git /opt/graphital
    cd /opt/graphital
    gem install daemons

### Configure

There is an example configuration file called `graphital.conf.eg` (that will
be loaded if nothing else is found). You should create your own configuration
file at `/etc/graphital.conf` or `/opt/graphital/graphital.conf`.

Make sure you set your Graphite server address in your `graphital.conf`:  

    $HOST = 'graphite.example.com'

### Run using `daemons` gem

This will invoke `graphital.rb` and put it into the background.  

    ruby /opt/graphital/daemon.rb start  

### Run as a service using Upstart (e.g. on Ubuntu or Fedora)

Rather than using the `daemons` gem, you can run `graphital.rb` directly, and
use another method for making it a service that can be started, tracked and
stopped.

On systems using [Upstart](http://upstart.ubuntu.com/cookbook/), this is as
easy as adding a `/etc/init/graphital.conf` file like:

    description     "send system vitals to graphite"

    start on runlevel [2345]
    stop on runlevel [!2345]

    respawn

    exec /usr/bin/ruby /opt/graphital/graphital.rb

Try it out with:

    service graphital start
    service graphital status
    service graphital restart

