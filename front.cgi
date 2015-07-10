#!/usr/bin/perl

use strict;
use warnings;

#This script will be the main interface to talk with the Amazon Echo servers
#and accept and return requests. This script will talk with the 'calc_days.pl'
#script and return the output.

#This may also interface with another script (or be incorperated into this one)
#to add entries to the 'events.cvs' file.

use LWP::UserAgent;
use HTTP::Request::Common;
use JSON;


