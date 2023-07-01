use strict;
no warnings;

use enum qw(False True);
use constant Nr => <3 0 0 0 0 1 1 1 1 2 2 2 2 3 3 3>;
use constant Nc => <3 0 1 2 3 0 1 2 3 0 1 2 3 0 1 2>;

my ($n, $m) = (0, 0);
my(@N0, @N2, @N3, @N4);

sub fY {
   printf "Solution found in $n moves: %s\n", join('', @N3) and exit if $N2[$n] == 0x123456789abcdef0;
   $N4[$n] <= $m ? fN() : False;
}

sub fN {
   sub common { ++$n; return True if fY(); --$n }
   if ($N3[$n] ne 'u' and int($N0[$n] / 4) < 3) { fI(); common() }
   if ($N3[$n] ne 'd' and int($N0[$n] / 4) > 0) { fG(); common() }
   if ($N3[$n] ne 'l' and    ($N0[$n] % 4) < 3) { fE(); common() }
   if ($N3[$n] ne 'r' and    ($N0[$n] % 4) > 0) { fL(); common() }
   return False;
}

sub fI {
   my $g = (11-$N0[$n])*4;
   my $a = $N2[$n] & (15 << $g);
   $N0[$n+1] = $N0[$n]+4;
   $N2[$n+1] = $N2[$n]-$a+($a<<16);
   $N4[$n+1] = $N4[$n]+((Nr)[$a>>$g] <= int($N0[$n] / 4) ? 0 : 1);
   $N3[$n+1] = 'd';
}

sub fG {
   my $g = (19-$N0[$n])*4;
   my $a = $N2[$n] & (15 << $g);
   $N0[$n+1] = $N0[$n]-4;
   $N2[$n+1] = $N2[$n]-$a+($a>>16);
   $N4[$n+1] = $N4[$n]+((Nr)[$a>>$g] >= int($N0[$n] / 4) ? 0 : 1);
   $N3[$n+1] = 'u';
}

sub fE {
   my $g = (14-$N0[$n])*4;
   my $a = $N2[$n] & (15 << $g);
   $N0[$n+1] = $N0[$n]+1;
   $N2[$n+1] = $N2[$n]-$a+($a<<4);
   $N4[$n+1] = $N4[$n]+((Nc)[$a>>$g] <= $N0[$n]%4 ? 0 : 1);
   $N3[$n+1] = 'r';
}

sub fL {
   my $g = (16-$N0[$n])*4;
   my $a = $N2[$n] & (15 << $g);
   $N0[$n+1] = $N0[$n]-1;
   $N2[$n+1] = $N2[$n]-$a+($a>>4);
   $N4[$n+1] = $N4[$n]+((Nc)[$a>>$g] >= $N0[$n]%4 ? 0 : 1);
   $N3[$n+1] = 'l';
}

($N0[0], $N2[0]) = (8, 0xfe169b4c0a73d852); # initial state
while () { fY() or ++$m }
