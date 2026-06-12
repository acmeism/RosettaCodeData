say display 10, '%3d', ^1000 .grep: { .comb.Bag{'1'} == 2 };

sub display {
    cache $^c;
    "{+$c} matching:\n" ~ $c.batch($^a)».fmt($^b).join: "\n"
}
