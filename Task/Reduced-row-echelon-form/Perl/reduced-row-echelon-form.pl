sub rref
 {our @m; local *m = shift;
  @m or return;
  my ($lead, $rows, $cols) = (0, scalar(@m), scalar(@{$m[0]}));

  foreach my $r (0 .. $rows - 1)
     {$lead < $cols or return;
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

      ++$lead;}}

sub display { join("\n" => map join(" " => map(sprintf("%4d", $_), @$_)), @{+shift})."\n" }

@m =
(
   [  1,  2,  -1,  -4 ],
   [  2,  3,  -1, -11 ],
   [ -2,  0,  -3,  22 ]
);

rref(\@m);
print display(\@m);
