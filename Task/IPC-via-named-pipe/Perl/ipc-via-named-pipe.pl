# 20200924 added Perl programming solution

use strict;
use warnings;

use File::Temp qw/ :POSIX /;
use POSIX qw/ mkfifo /;
use Fcntl;

my ($in, $out) = map { scalar tmpnam() } 0,1 ;

for ($in, $out) { mkfifo($_,0666) or die $! };

print "In  pipe : $in\nOut pipe : $out\n";

my $CharCount = 0 ;

$SIG{INT} = sub {
   for ($in, $out) { unlink $_ or die }
   print "\nTotal Character Count: $CharCount\nBye.\n" and exit
};

sysopen(  IN,  $in, O_NONBLOCK|O_RDONLY ) or die;
sysopen( OUT, $out, O_NONBLOCK|O_RDWR   ) or die;

while (1) {
   sysread(IN, my $buf, 32); # borrowed the buffer size from the c entry
   if ( length $buf > 0 ) {
      $CharCount += length $buf;
      while (sysread(OUT, $buf, 1)) {} ; # empty the write pipe
      syswrite( OUT, $CharCount ) or die;
   }
   sleep .5;
}
