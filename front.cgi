#!/usr/bin/perl

use strict;
use warnings;

#This script will be the main interface to talk with the Amazon Echo servers
#and accept and return requests. This script will talk with the 'calc_days.pl'
#script and return the output.

#This may also interface with another script (or be incorperated into this
#one) to add entries to the 'events.cvs' file.

use CGI qw(:standard);
use LWP::UserAgent 6;
use HTTP::Request::Common;
use JSON;
use autodie;


#Make variables to hold the header and JSON data that will be sent.
my header;
my json;

#Get the data passed to the script. It should be sent via POST, so this will
#grab all of the input passed to the server.
read(STDIN, my $input, $ENV{'CONTENT_LENGTH'});





#Check the signiture of the request made. If it is actually from Amazon,
#continue. Otherwise return an error to the request and exit. This script
#only needs to verify the URL is from Amazon; checking the if cert is valid
#is now done by default by 'LWP::UserAgent' version 6.

#Get signiture and the certificate from the headers of the request. This will
#determine if the requestif actually from Amazon or not.
my $sig  = $ENV{"HTTP_SIGNITURE"};
my $cert = $ENV{"HTTP_SIGNITURECERTCHAINURL"};

#Verify the certificate is from Amazon.
if (&verify_cert($cert)) {
    #Print out the correct HTTP header.
    header = header(    -status  => '200 OK',
                        -type    => 'application/json;charset=UTF-8',
                        -Content_length    => 'SIZE');
}
else {
    #Print out a 401 error and exit.
    print header('401 Unauthorized');
    exit;
}







#This funtion will be used to verify the certificate given by the request.
#Checking the certificate is done inside a function because amazon may change
#this at some point and it would be easier to fix in a function.
sub verify_cert {
    #Get the url.
    my ($cert) = @_;
    
    if ($cert =~ m/^https:\/\/s3.amazonaws.com(|\:443)\//i and
        $cert =~ m/\/echo.api\//) {
        return 1;
    }
}