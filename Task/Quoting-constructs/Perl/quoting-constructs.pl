# 20221202 Perl programming solution

use strict;
use warnings;

print <<`EXEC`                     # superfluous alternative to qx/ / and ` `
sleep 2; ls /etc/resolv.conf
EXEC
;
            # only with quoted begin tag then you can have spaces in between
print <<END # so <<  'END' or <<     "END" and semi-colon is always optional
Make sure that the end tag must be exactly the same as the begin tag.
END
; # the above wouldn't have worked had it been something like
  # END␣ ␣ ␣ (with redundant trailing spaces)

print <<"HERE1", <<"HERE2"    # it is also possible to stack heredocs
Hello from HERE1
HERE1
Hello from HERE2
HERE2
;

my $haystack = 'Santa says HoHoHo'; # a quoted pattern expanded before
my $needle   = "\x48\x6F";          # the regex is interpreted
print "1) Found.\n" if $haystack =~  /$needle{3}/;   # Matches Hooo
print "2) Found.\n" if $haystack =~ /($needle){3}/;  # Do what you mean

                  # due to autoconversion, things may still work the same
{  use Benchmark; # under (usually overlooked) scalar interpolation
   my ( $iterations, $x, $y ) = 1e7, rand, rand;
   timethese( $iterations, { 'normal'   => ' $x  +  $y',
                             'useless'  => '"$x" + "$y"' } );
} # however in the 2nd case the boxing and unboxing are unnecessary

{ # the following illustrate some behaviors under array interpolation
   my @Y_M_D = sub{$_[5]+1900,$_[4]+1,$_[3]}->(localtime(time));
   local  $\ = "\n";
   print  @Y_M_D;     # YMD
   print "@Y_M_D";    # Y M D
   local  $, = '-';   # output field separator
   print  @Y_M_D;     # Y-M-D
   print "@Y_M_D";    # Y M D
   local  $" = '_';   # interpolated list separator
   print "@Y_M_D";    # Y_M_D
}
