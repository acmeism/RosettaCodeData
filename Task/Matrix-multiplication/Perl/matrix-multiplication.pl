sub mmult
 {
  our @a; local *a = shift;
  our @b; local *b = shift;
  my @p = [];
  my $rows = @a;
  my $cols = @{ $b[0] };
  my $n = @b - 1;
  for (my $r = 0 ; $r < $rows ; ++$r)
     {
      for (my $c = 0 ; $c < $cols ; ++$c)
         {
          $p[$r][$c] += $a[$r][$_] * $b[$_][$c]
           foreach 0 .. $n;
         }
     }
  return [@p];
 }

sub display { join("\n" => map join(" " => map(sprintf("%4d", $_), @$_)), @{+shift})."\n" }

@a =
(
   [1, 2],
   [3, 4]
);

@b =
(
   [-3, -8, 3],
   [-2,  1, 4]
);

$c = mmult(\@a,\@b);
display($c)
