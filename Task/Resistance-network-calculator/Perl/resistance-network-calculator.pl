use strict;
use warnings;

sub gauss {
  our @m; local *m = shift;
  my ($lead, $rows, $cols) = (0, scalar(@m), scalar(@{$m[0]}));
  foreach my $r (0 .. $rows - 1) {
     $lead < $cols or return;
      my $i = $r;
      until ($m[$i][$lead])
         {++$i == $rows or next;
          $i = $r;
          ++$lead == $cols and return;}
      @m[$i, $r] = @m[$r, $i];
      my $lv = $m[$r][$lead];
      $_ /= $lv foreach @{ $m[$r] };
      my @mr = @{ $m[$r] };
      foreach my $i (0 .. $rows - 1)
         {$i == $r and next;
          ($lv, my $n) = ($m[$i][$lead], -1);
          $_ -= $lv * $mr[++$n] foreach @{ $m[$i] };}
      ++$lead;}
}

sub network {
    my($n,$k0,$k1,$grid) = @_;
    my @m;
    push @m, [(0)x($n+1)] for 1..$n;

    for my $resistor (split '\|', $grid) {
        my ($a,$b,$r_inv) = split /\s+/, $resistor;
        my $r = 1 / $r_inv;
        $m[$a][$a] += $r;
        $m[$b][$b] += $r;
        $m[$a][$b] -= $r if $a > 0;
        $m[$b][$a] -= $r if $b > 0;
    }
    $m[$k0][$k0] = 1;
    $m[$k1][ -1] = 1;
    gauss(\@m);
    return $m[$k1][-1];
}

for (
    [   7, 0,     1, '0 2 6|2 3 4|3 4 10|4 5 2|5 6 8|6 1 4|3 5 6|3 6 6|3 1 8|2 1 8' ],
    [ 3*3, 0, 3*3-1, '0 1 1|1 2 1|3 4 1|4 5 1|6 7 1|7 8 1|0 3 1|3 6 1|1 4 1|4 7 1|2 5 1|5 8 1' ],
    [ 4*4, 0, 4*4-1, '0 1 1|1 2 1|2 3 1|4 5 1|5 6 1|6 7 1|8 9 1|9 10 1|10 11 1|12 13 1|13 14 1|14 15 1|0 4 1|4 8 1|8 12 1|1 5 1|5 9 1|9 13
1|2 6 1|6 10 1|10 14 1|3 7 1|7 11 1|11 15 1' ],
    [   4, 0,     3, '0 1 150|0 2 50|1 3 300|2 3 250' ],
) {
    printf "%10.3f\n", network(@$_);
}
