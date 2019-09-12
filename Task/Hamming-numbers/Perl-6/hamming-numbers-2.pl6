my \Hammings := gather {
  my %i = 2, 3, 5 Z=> (Hammings.iterator for ^3);
  my %n = 2, 3, 5 Z=> 1 xx 3;

  loop {
    take my $n := %n{2, 3, 5}.min;

    for 2, 3, 5 -> \k {
      %n{k} = %i{k}.pull-one * k if %n{k} == $n;
    }
  }
}

say Hammings.[^20];
say Hammings.[1691 - 1];
say Hammings.[1000000 - 1];
