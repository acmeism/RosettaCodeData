put display ^1000 .grep: { ($_ % 2) && .is-prime && (.comb[^(*-1)].all %% 2) }

sub display ($list, :$cols = 10, :$fmt = '%6d', :$title = "{+$list} matching:\n" )   {
    cache $list;
    $title ~ $list.batch($cols)».fmt($fmt).join: "\n"
}
