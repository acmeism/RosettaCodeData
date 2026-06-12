my @p = ^1e2 .grep: *.is-prime;

say display ( @p X~ @p ).grep( *.is-prime ).unique.sort( +* );

sub display ($list, :$cols = 10, :$fmt = '%6d', :$title = "{+$list} matching:\n") {
    cache $list;
    $title ~ $list.batch($cols)».fmt($fmt).join: "\n"
}
