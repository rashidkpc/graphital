#!/usr/bin/env bash
sar -u 1 5|tail -1| awk '{ print "user "$3"\nnice "$4"\nsystem "$5"\niowait "$6"\nsteal "$7"\nidle "$8 }'
