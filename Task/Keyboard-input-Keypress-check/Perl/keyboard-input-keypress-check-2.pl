#!/usr/bin/perl
use strict;
use warnings;
use Carp;
use POSIX;
use Term::ReadKey;
$| = 1; # don't buffer; stdout is hot now

#avoid creation of zombies
sub _cleanup_and_die{
	ReadMode('restore');
	print "process $$ dying\n";
	die;
}
sub _cleanup_and_exit{
	ReadMode('restore');
	print "process $$ exiting\n";
	exit 1;
}
$SIG{'__DIE__'} = \&_cleanup_and_die;
$SIG{'INT'}     = \&_cleanup_and_exit;
$SIG{'KILL'}    = \&_cleanup_and_exit;
$SIG{'TERM'}    = \&_cleanup_and_exit;
$SIG{__WARN__}  = \&_warn;

# fork into two processes:
# child process is doing anything
# parent process just listens to keyboard input
my $pid = fork();
if(not defined $pid){
	print "error: resources not available.\n";
	die "$!";
}elsif($pid == 0){ # child
	for(0..9){
		print "doing something\n";
		sleep 1;
	}
	exit 0;
}else{ # parent
	ReadMode('cbreak');
	# wait until child has exited/died
	while(waitpid($pid, POSIX::WNOHANG) == 0){
		my $seq = ReadKey(-1);
		if(defined $seq){
			print "got key '$seq'\n";
		}
		sleep 1; # if ommitted, the cpu-load will reach up to 100%
	}
	ReadMode('restore');
}
