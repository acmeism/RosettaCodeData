# 20240912 Perl programming solution

use strict;
use warnings;

sub nextword {
   my ($n, $w, $alphabet) = @_;
   my $x = substr($w x (int($n / length($w)) + 1), 0, $n);
   while ($x && substr($x, -1) eq substr($alphabet, -1)) {
      substr($x, -1) = ''
   }
   if ($x ne '') {
      my $next_char_index = (index($alphabet, substr($x, -1)) // 0) + 1;
      substr($x, -1, 1) = substr($alphabet, $next_char_index, 1);
   }
   return $x;
}

sub generate_words {
   my ($n, $alphabet) = @_;
   my $w = substr($alphabet, 0, 1);
   my @result;
   while (length($w) <= $n) {
      push @result, $w;
      last unless $w = nextword($n, $w, $alphabet);
   }
   return @result;
};

print "$_\n" for generate_words(5, '01');
