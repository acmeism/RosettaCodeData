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
