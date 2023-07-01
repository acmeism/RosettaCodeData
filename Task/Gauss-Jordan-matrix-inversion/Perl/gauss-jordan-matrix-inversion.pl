sub rref {
  our @m; local *m = shift;
  @m or return;
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

sub display { join("\n" => map join(" " => map(sprintf("%6.2f", $_), @$_)), @{+shift})."\n" }

sub gauss_jordan_invert {
    my(@m) = @_;
    my $rows = @m;
    my @i = identity(scalar @m);
    push @{$m[$_]}, @{$i[$_]} for 0..$rows-1;
    rref(\@m);
    map { splice @$_, 0, $rows } @m;
    @m;
}

sub identity {
    my($n) = @_;
    map { [ (0) x $_, 1, (0) x ($n-1 - $_) ] } 0..$n-1
}

my @tests = (
    [
      [ 2, -1,  0 ],
      [-1,  2, -1 ],
      [ 0, -1,  2 ]
    ],
    [
      [ -1, -2, 3, 2 ],
      [ -4, -1, 6, 2 ],
      [  7, -8, 9, 1 ],
      [  1, -2, 1, 3 ]
    ],
);

for my $matrix (@tests) {
    print "Original Matrix:\n" . display(\@$matrix) . "\n";
    my @gj = gauss_jordan_invert( @$matrix );
    print "Gauss-Jordan Inverted Matrix:\n" . display(\@gj) . "\n";
    my @rt = gauss_jordan_invert( @gj );
    print "After round-trip:\n" . display(\@rt) . "\n";} . "\n"
}
