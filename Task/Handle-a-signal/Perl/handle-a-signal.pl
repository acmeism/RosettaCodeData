my $start = time;  # seconds since epohc
my $arlm=5;  # every 5 seconds show how we're doing
my $i;

$SIG{QUIT} = sub
   {print " Ran for ", time - $start, " seconds.\n"; die; };
$SIG{INT} = sub
   {print " Running for ", time - $start, " seconds.\n"; };
$SIG{ALRM} = sub
   {print " After $arlm  seconds i= $i. Executing for ",  time - $start, " seconds.\n";  alarm $arlm };


alarm $arlm;  # trigger ALaRM after we've run  for a while

print " ^C to inerrupt, ^\\ to quit, takes a break at $arlm seconds \n";

while ( 1 ) {
   for ( $w=11935000; $w--; $w>0 ){}; # spinning is bad, but hey it's only a demo

    print (  ++$i," \n");
            }
 ^C to inerrupt, ^\ to quit, takes a break at 5 seconds
1
2
^C Running for 1 seconds.
3
4
^C Running for 2 seconds.
5
6
7
^C Running for 3 seconds.
8
9
10
 After 5  seconds i= 10. Executing for 5 seconds.
11
12
13
14
15
16
17
18
19
20
 After 5  seconds i= 20. Executing for 10 seconds.
21
22
^\ Ran for 11 seconds.
Died at 0.pl line 6..


This example does the required task:
<lang perl>use 5.010;
use AnyEvent;
my $start = AE::time;
my $exit = AE::cv;
my $int = AE::signal 'INT', $exit;
my $n;
my $num = AE::timer 0, 0.5, sub { say $n++ };
$exit->recv;
say " interrupted after ", AE::time - $start, " seconds";
