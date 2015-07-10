#!/usr/bin/perl

use strict;
use warnings;

#This script will be the main interface to talk with the Amazon Echo servers
#and accept and return requests. This script will talk with the 'calc_days.pl'
#script and return the output.

#This may also interface with another script (or be incorperated into this
#one) to add entries to the 'events.cvs' file.

use LWP::UserAgent 6;
use HTTP::Request::Common;
use JSON;
use autodie;

#Get the data passed to the script. It should be sent via POST.
read(STDIN, my $input, $ENV{'CONTENT_LENGTH'});

#Get signiture and the certificate from the headers of the request. This will
#determine if the requestif actually from Amazon or not.
my $sig  = $ENV{"HTTP_SIGNITURE"};
my $cert = $ENV{"HTTP_SIGNITURECERTCHAINURL"};

#Verify the certificate is from Amazon.
&verify_cert($cert);

#Print out the HTTP header.
print <<'END';
HTTP/1.1 200 OK
Content-Type: application/json;charset=UTF-8
Content-Length:
END





#This funtion will be used to verify the certificate given by the request.
#Checking the certificate is done inside a function because amazon may change
#this at some point and it would be easier to fix in a function.
sub verify_cert {
    #Get the url.
    my ($cert) = @_;
    
    if ($cert =~ m/^https:\/\/s3.amazonaws.com(:443)/i and
        $cert =~ m/\/echo.api\//) {
        return 1;
    }
    
}