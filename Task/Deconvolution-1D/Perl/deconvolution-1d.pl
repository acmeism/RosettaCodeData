use v5.36;
use Math::Cartesian::Product;

sub deconvolve($g,$f) {
    my @g = @{$g};
    my @f = @{$f};
    my(@m,@d);

    my $h = 1 + @g - @f;
    push @m, [(0) x $h, $g[$_]] for 0..$#g;
    for my $j (0..$h-1) {
        for my $k (0..$#f) {
            $m[$j + $k][$j] = $f[$k]
        }
    }
    rref(\@m);
    push @d, @{ $m[$_] }[$h] for 0..$h-1;
    @d;
}

sub convolve($f,$h) {
    my @f = @{$f};
    my @h = @{$h};
    my @i;
    for my $x (cartesian {@_} [0..$#f], [0..$#h]) {
        push @i, @$x[0]+@$x[1];
    }
    my $cnt = 0;
    my @g = (0) x (@f + @h - 1);
    for my $x (cartesian {@_} [@f], [@h]) {
        $g[$i[$cnt++]] += @$x[0]*@$x[1];
    }
    @g;
}

sub rref($m) {
  my @m = @{$m};
  @m or return;
  my ($lead, $rows, $cols) = (0, scalar(@m), scalar(@{$m[0]}));

  for my $r (0 .. $rows - 1) {
      $lead < $cols or return;
      my $i = $r;

      until ($m[$i][$lead]) {
          ++$i == $rows or next;
          $i = $r;
          ++$lead == $cols and return;
      }

      @m[$i, $r] = @m[$r, $i];
      my $lv = $m[$r][$lead];
      $_ /= $lv foreach @{ $m[$r] };

      my @mr = @{ $m[$r] };
      for my $i (0 .. $rows - 1) {
          $i == $r and next;
          ($lv, my $n) = ($m[$i][$lead], -1);
          $_ -= $lv * $mr[++$n] foreach @{ $m[$i] };
      }
      ++$lead;
   }
}

my @h = qw<-8 -9 -3 -1 -6 7>;
my @f = qw<-3 -6 -1 8 -6 3 -1 -9 -9 3 -2 5 2 -2 -7 -1>;
print '  conv(f,h) = g = ' . join(' ', my @g = convolve(\@f, \@h)) . "\n";
print 'deconv(g,f) = h = ' . join(' ', deconvolve(\@g, \@f)) . "\n";
print 'deconv(g,h) = f = ' . join(' ', deconvolve(\@g, \@h)) . "\n";
