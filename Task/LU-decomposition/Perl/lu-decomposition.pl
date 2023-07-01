use List::Util qw(sum);

for $test (
    [[1, 3, 5],
     [2, 4, 7],
     [1, 1, 0]],

    [[11,  9, 24,  2],
     [ 1,  5,  2,  6],
     [ 3, 17, 18,  1],
     [ 2,  5,  7,  1]]
) {
    my($P, $AP, $L, $U) = lu(@$test);
    say_it('A matrix', @$test);
    say_it('P matrix',  @$P);
    say_it('AP matrix', @$AP);
    say_it('L matrix',  @$L);
    say_it('U matrix',  @$U);

}

sub lu {
    my (@a) = @_;
    my $n = +@a;
    my @P  = pivotize(@a);
    my $AP = mmult(\@P, \@a);
    my @L  = matrix_ident($n);
    my @U  = matrix_zero($n);
    for $i (0..$n-1) {
        for $j (0..$n-1) {
            if ($j >= $i) {
                $U[$i][$j] =  $$AP[$i][$j] - sum map { $U[$_][$j] * $L[$i][$_] } 0..$i-1;
            } else {
                $L[$i][$j] = ($$AP[$i][$j] - sum map { $U[$_][$j] * $L[$i][$_] } 0..$j-1) / $U[$j][$j];
            }
        }
    }
    return \@P, $AP, \@L, \@U;
}

sub pivotize {
    my(@m) = @_;
    my $size = +@m;
    my @id = matrix_ident($size);
    for $i (0..$size-1) {
        my $max = $m[$i][$i];
        my $row = $i;
        for $j ($i .. $size-2) {
            if ($m[$j][$i] > $max) {
                $max = $m[$j][$i];
                $row = $j;
            }
        }
        ($id[$row],$id[$i]) = ($id[$i],$id[$row]) if $row != $i;
    }
    @id
}

sub matrix_zero  { my($n) = @_; map { [ (0) x $n ] } 0..$n-1 }
sub matrix_ident { my($n) = @_; map { [ (0) x $_, 1, (0) x ($n-1 - $_) ] } 0..$n-1 }

sub mmult {
  local *a = shift;
  local *b = shift;
  my @p = [];
  my $rows = @a;
  my $cols = @{ $b[0] };
  my $n = @b - 1;
  for (my $r = 0 ; $r < $rows ; ++$r) {
      for (my $c = 0 ; $c < $cols ; ++$c) {
          $p[$r][$c] += $a[$r][$_] * $b[$_][$c] foreach 0 .. $n;
      }
  }
  return [@p];
}

sub say_it {
    my($message, @array) = @_;
    print "$message\n";
    $line = sprintf join("\n" => map join(" " => map(sprintf("%8.5f", $_), @$_)), @{+\@array})."\n";
    $line =~ s/\.00000/      /g;
    $line =~ s/0000\b/    /g;
    print "$line\n";
}
