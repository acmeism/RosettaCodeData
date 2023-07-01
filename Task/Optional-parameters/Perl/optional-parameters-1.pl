sub sorttable
 {my @table = @{shift()};
  my %opt =
     (ordering => sub {$_[0] cmp $_[1]}, column => 0, reverse => 0, @_);
  my $col = $opt{column};
  my $func = $opt{ordering};
  my @result = sort
      {$func->($a->[$col], $b->[$col])}
      @table;
  return ($opt{reverse} ? [reverse @result] : \@result);}
