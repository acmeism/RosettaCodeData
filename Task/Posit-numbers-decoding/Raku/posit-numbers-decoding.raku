=begin LICENSE
Copyright © 2017 John L. Gustafson

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sub-license, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

This copyright and permission notice shall be included in all copies or substantial portions of the software.

THE SOFTWARE IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT
LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN
NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER LIABILITY,
WHETHER IN AN ACTION OR CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
=end LICENSE

constant nbits = 16;
constant es    = 3;
constant npat  = 2**nbits;
constant useed = 2**2**es;
constant minpos = useed**(-nbits + 2);
constant maxpos = useed**(+nbits - 2);
constant qsize  = 2**((nbits-2)*2**(es+2)+5).log2.ceiling;
constant qextra = qsize - (nbits - 2)*2**(es+2);

constant posit-range = 0..^2**nbits;

sub twoscomp($sign, $p) { ($sign > 0 ?? $p !! npat - $p) mod npat }

sub sign-bit(UInt $p where posit-range) { +$p.polymod(2 xx nbits - 1).tail }
sub regime-bits(UInt $p where posit-range) {
  my $q = twoscomp(1 - sign-bit($p), $p);
  my @bits = $q.polymod(2 xx nbits - 1).reverse;
  my $bit2 = @bits[1];
  my @temp-bits = flat @bits[1..*], 1 - $bit2;
  my $npower = @temp-bits.first(1 - $bit2, :k) - 1;
  @bits[1..($npower+1)];
}
sub regime-value(@bits) { @bits.head ?? @bits.elems - 1 !! -@bits; }
sub exponent-bits(UInt $p where posit-range) {
  my $q = twoscomp(1 - sign-bit($p), $p);
  my $startbit = regime-bits($q).elems + 3;
  my @bits = $q.polymod(2 xx nbits - 1).reverse;
  @bits[$startbit-1 .. $startbit-1 + es - 1]
}
sub fraction-bits(UInt $p where posit-range) {
  my $q = twoscomp(1 - sign-bit($p), $p);
  my $startbit = regime-bits($q).elems + 3 + es;
  my @bits = $q.polymod(2 xx nbits - 1).reverse;
  @bits[$startbit-1 .. *];
}

sub p2x(UInt $p where posit-range) {
  my $s = (-1)**sign-bit($p);
  my $k = regime-value regime-bits $p;
  my @e = exponent-bits $p;
  my @f = fraction-bits $p;
  @e.push: 0 until @e == es;
  my $e = @e.reduce: 2 * * + *;
  my $f = @f == 0 ?? 1 !! 1.FatRat + @f.reduce(2 * * + *)/2**@f;
  given $p {
    when 0          { 0   }
    when npat div 2 { Inf }
    default         { $s * useed**$k * 2**$e * $f }
  }
}

dd p2x 0b0000110111011101;
