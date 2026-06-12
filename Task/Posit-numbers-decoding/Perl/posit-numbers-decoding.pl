# 20240929 Perl programming solution

use strict;
use warnings;
use Math::BigRat;

use constant { NBITS => 16, ES => 3, NPAT => 2**16, USEED => 256, };

sub twoscomp {
   my ($sign, $p) = @_;
   return ($sign > 0 ? $p : NPAT - $p) % NPAT;
}

sub sign_bit {
   my ($p) = @_;
   return ($p >> (NBITS - 1)) & 1;
}

sub regime_bits {
   my ($p) = @_;
   my $q = twoscomp(1 - sign_bit($p), $p);
   my $bit_str = sprintf("%0*b", NBITS, $q);
   my $first_data_bit = substr($bit_str, 1, 1);
   my $count = 0;

   foreach my $i (1 .. length($bit_str) - 1) {
      last if substr($bit_str, $i, 1) ne $first_data_bit;
      $count++;
   }
   return ($first_data_bit eq '1') ? $count : -($count);
}

sub regime_value {
   my ($p) = @_;
   return regime_bits($p);
}

sub exponent_bits {
   my ($p) = @_;
   my $q = twoscomp(1 - sign_bit($p), $p);
   my $bit_str = sprintf("%0*b", NBITS, $q);
   my $regime_len = abs(regime_bits($p));
   my $start_bit = 1 + $regime_len + 1;
   return substr($bit_str, $start_bit, ES);
}

sub fraction_bits {
   my ($p) = @_;
   my $q = twoscomp(1 - sign_bit($p), $p);
   my $bit_str = sprintf("%0*b", NBITS, $q);
   my $regime_len = abs(regime_bits($p));
   my $start_bit = 1 + $regime_len + ES + 1;
   return substr($bit_str, $start_bit);
}

sub bin_to_dec {
   my ($bin) = @_;
   return unpack("N", pack("B32", substr("0" x 32 . $bin, -32)));
}

sub fraction_value {
   my ($bits) = @_;
   my $value = Math::BigRat->new(1);
   my $frac_len = length($bits);

   for my $i (0 .. $frac_len - 1) {
      my $bit = substr($bits, $i, 1);
      $value += Math::BigRat->new($bit) / (2 ** ($i + 1));
   }
   return $value;
}

sub p2x {
   my ($p) = @_;
   my $sign = (-1) ** sign_bit($p);
   my $k = regime_value($p);
   my $e_bits = exponent_bits($p);
   my $e = bin_to_dec($e_bits);
   my $f_bits = fraction_bits($p);
   my $f = fraction_value($f_bits);

   if ($p == 0) {
      return Math::BigRat->new(0);
   } elsif ($p == NPAT / 2) {
      return "Inf";
   } else {
      my $USEED_k = Math::BigRat->new(USEED) ** $k;
      my $two_e = Math::BigRat->new(2) ** $e;
      my $result = Math::BigRat->new($sign) * $USEED_k * $two_e * $f;
      return $result;
   }
}

print p2x(0b0000110111011101), "\n";
