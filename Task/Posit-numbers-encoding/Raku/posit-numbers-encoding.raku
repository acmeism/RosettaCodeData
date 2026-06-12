=begin LICENSE
Copyright © 2017 John L . Gustafson

Permission is hereby granted, free of charge to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction including without limitation the rights to use copy, modify, merge, publish, distribute, sub - license, and/or sell copies of the Software and to permit persons to whom the Software is furnished to do so, subject to the following conditions :

This copyright and permission notice shall be included in all copies or substantial portions of the software .

THE SOFTWARE IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT . IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER LIABILITY, WHETHER IN AN ACTION OR CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE .
=end LICENSE

# L<https://posithub.org/docs/Posits4.pdf>
constant nbits = 8;
constant es    = 2;
constant npat  = 2**nbits;
constant useed = 2**2**es;
constant minpos = useed**(-nbits + 2);
constant maxpos = useed**(+nbits - 2);
constant qsize  = 2**((nbits-2)*2**(es+2)+5).log2.ceiling;
constant qextra = qsize - (nbits - 2)*2**(es+2);

constant posit-range = ^npat;
subset posit of UInt where posit-range;

sub x2p(Real $x --> posit) {

  # first, take care of the two exceptional values
  return 0 if $x == 0;
  return npat div 2 if $x == Inf;

  # working variables
  my ($i, $p, $e, $y) = $, $, 2**(es - 1), $x.abs;


  if $y ≥ 1 { # north-east quadrant
    ($p, $i) = 1, 2;
    # Shift in 1s from the right and scale down.
    ($p, $y, $i) = 2*$p+1, $y/useed, $i+1 while $y ≥ useed && $i ≤ nbits;
    $p *= 2; $i++;
  } else { # south-east quadrant
    ($p, $i) = 0, 1;
    # Shift in 0 s from the right and scale up.
    ($y, $i) = $y*useed, $i+1 while $y < 1 && $i ≤ nbits;
    if $i ≥ nbits {
      $p = 2; $i = nbits + 1;
    } else { $p = 1; $i++; }
  }
  # Extract exponent bits:
  while $e > 1/2 and $i ≤ nbits {
    $p *= 2;
    if $y ≥ 2**$e { $y /= 2**$e; $p++ }
    $e /= 2;
    $i++;
  }
  $y--;
  # Fraction bits; substract the hidden bit
  while $y > 0 and $i ≤ nbits {
    $y *= 2;
    $p = 2*$p + $y.floor;
    $y -= $y.floor;
    $i++
  }
  $p *= 2**(nbits+1-$i);
  $i++;

  # Round to nearest; tie goes to even
  $i = $p +& 1;
  $p = ($p/2).floor;
  $p = $i == 0 ?? $p !!
       $y == 0|1 ?? $p + $p+&1 !!
       $p + 1;

  # Simulate 2's complement
  ($x < 0 ?? npat - $p !! $p) mod npat;

}

say x2p pi;
