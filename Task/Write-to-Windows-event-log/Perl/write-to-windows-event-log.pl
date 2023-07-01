use strict;
use warnings;

use Win32::EventLog;
my $handle = Win32::EventLog->new("Application");

my $event = {
	Computer 	=>	$ENV{COMPUTERNAME},
	Source		=> 	'Rosettacode',
	EventType 	=> 	EVENTLOG_INFORMATION_TYPE,
	Category  	=> 	'test',
	EventID 	=> 	0,
	Data 		=> 	'a test for rosettacode',
	Strings 	=> 	'a string test for rosettacode',
};
$handle->Report($event);
