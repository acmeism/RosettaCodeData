$target = "/dev/pts/51";
### How to get the correct value for $TIOCSTI is discussed here : http://www.perlmonks.org/?node_id=10920
$TIOCSTI = 0x5412 ;
open(TTY,">$target") or die "cannot open $target" ;
$b="sleep 99334 &\015";
@c=split("",$b);
sleep(2);
foreach $a ( @c ) { ioctl(TTY,$TIOCSTI,$a); select(undef,undef,undef,0.1);} ;
print "DONE\n";
