sub comma { ($^i < 0 ?? '-' !! '') ~ $i.abs.flip.comb(3).join(',').flip }

my \x     =  5;
my \y     = -5;
my \z     = -2;
my \one   =  1;
my \three =  3;
my \seven =  7;

my $j = flat
  ( -three, *+three … 3³         ),
  ( -seven, *+x     …^ * > seven ),
  ( 555   .. 550 - y             ),
  ( 22,     *-three …^ * < -28   ),
  ( 1927  .. 1939                ),
  ( x,      *+z     …^ * < y     ),
  ( 11**x .. 11**x + one         );

put 'j sequence: ', $j;
put '       Sum: ', comma [+] $j».abs;
put '   Product: ', comma ([\*] $j.grep: so +*).first: *.abs > 2²⁷;

# Or, an alternate method for generating the 'j' sequence, employing user-defined
# operators to preserve the 'X to Y by Z' layout of the example code.
# Note that these operators will only work for monotonic sequences.

sub infix:<to> { $^a ... $^b }
sub infix:<by> { $^a[0, $^b.abs ... *] }

$j = cache flat
    -three  to          3**3  by  three ,
    -seven  to         seven  by      x ,
       555  to     (550 - y)            ,
        22  to           -28  by -three ,
      1927  to          1939  by    one ,
         x  to             y  by      z ,
     11**x  to (11**x + one)            ;

put "\nLiteral minded variant:";
put '       Sum: ', comma [+] $j».abs;
put '   Product: ', comma ([\*] $j.grep: so +*).first: *.abs > 2²⁷;
