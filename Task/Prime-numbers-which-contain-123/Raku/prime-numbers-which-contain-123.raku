my @p123 = ^∞ .grep: { (.contains: 123) && .is-prime };

put display @p123[^(@p123.first: * > 1e5, :k)];

put "\nCount up to 1e6: ", ~ +@p123[^(@p123.first: * > 1e6, :k)];

sub display ($list, :$cols = 10, :$fmt = '%6d', :$title = "{+$list} matching:\n" )   {
    cache $list;
    $title ~ $list.batch($cols)».fmt($fmt).join: "\n"
}
