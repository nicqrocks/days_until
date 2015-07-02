#!/usr/bin/perl

use strict;
use warnings;
use diagnostics;

#Import the Date::Calc module, it's easier.
use Date::Calc qw(Today Delta_Days This_Year);

#This script will be used to calculate the number of days left
#before a certain date. This script expects the date of the
#'event' to be given as the argument. This can be a regular
#date given in numerical [YEAR]/[MONTH]/[DAY] format or a 
#string to a particular day refered to as an 'event'. These
#are described in the file refered to in the '$file' variable.


#This is the file the events will be stored in. This can be
#changed if needed.
my $file = 'events.csv';

#Make a hash to hold the names of each month nad their number.
my %months = (
	january		=> 1,
	february	=> 2,
	march		=> 3,
	april		=> 4,
	may			=> 5,
	june		=> 6,
	july		=> 7,
	august		=> 8,
	september	=> 9,
	october		=> 10,
	november	=> 11,
	december	=> 12
);

#Get the events saved.
my %events;
&get_events($file, \%events);
#print "$_ = $events{$_}\n" for (keys %events); #For debugging.



#############################################################
#Get the user's input and calculate the amount of days until
#the day specified.
#############################################################

#Variable to store the current date.
my ($cur_year, $cur_month, $cur_day) = Today();

#Make a regex variable to find an event name.
my $find_event = join( '|', map( quotemeta, keys %events));

#Make a regex variable to use when finding a month name in the input.
my $find_month = join( '|', map( quotemeta, keys %months));

#Variable to store the date wanted.
my $event_date;


#Begin checking through the given input.
while (@ARGV) {
	#Check if the input given is a date.
	if		($ARGV[0] =~ m[^\d{2,4}/\d{1,2}/\d{1,2}$]) {$event_date = shift;}
	
	#Check if the input is an event.
	elsif	($ARGV[0] =~ m/^($find_event)/) {
		#Check if the user's input matches a saved event.
		for my $event (keys %events) {
			if	($ARGV[0] eq $event) {$event_date = $events{$ARGV[0]}; shift;}
		}
	}
	
	#Check if the input is given in '[MONTH_NAME] [day]' format.
	elsif	($ARGV[0] =~ /^($find_month)\s+\d{1,2}/i) {
		#Set the input to 'event_date'.
		$event_date = shift;
		#Use a regular expression to change the writen form of the
		#month into the numeric form using the 'months' hash.
		$event_date =~ s[(?<name>\w+)\s+][$months{ $+{name} }/]gx;
		#Add the current year to the variable.
		$event_date = This_Year() ."/". $event_date;
	}
	
	else	{print "Agrument '$ARGV[0]' invalid.\n"; shift;}
}

#Check if anything was saved in the 'event_date' variable
die "No arguments given were accepted" if not $event_date;

#Split the 'event_date' variable into the year, month, and day using
#the split command.
my ($evn_year, $evn_month, $evn_day) = split('/', $event_date);

#Save the difference in days as a variable.
my $days_until = Delta_Days($cur_year, $cur_month, $cur_day,
							$evn_year, $evn_month, $evn_day);

#############################################################
#Function to import the events file.
#############################################################

sub get_events {
	my ($file_to_use, $event_hash) = @_;
	#Make file handle for the file.
	open(my $CONFIG, '<', $file_to_use) or die "Cannot open the config file.";
	
	#Go through each line of the configuration file and set the
	#values to a key value pair in the '%event_hash' reference.
	while (my $line = <$CONFIG>) {
		#Get rid of the new line.
		chomp $line;
		
		#Check if the line is a comment or if there is no text
		#in it. If so, skip the line.
		if ($line =~ /^\s*#/ or $line =~ /^\s*$/) {
			next;
		}
		
		#Seperate by ',' and add the pair to the hash.
		my @pair = split(',', $line);
		$event_hash->{$pair[0]} = $pair[1];
	}
}

