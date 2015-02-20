use Data::Dumper qw(Dumper);

sub hashJoin {
    my ($table1, $index1, $table2, $index2) = @_;
    my %h;
    # hash phase
    foreach my $s (@$table1) {
	push @{ $h{$s->[$index1]} }, $s;
    }
    # join phase
    map { my $r = $_;
	  map [$_, $r], @{ $h{$r->[$index2]} }
    } @$table2;
}

@table1 = ([27, "Jonah"],
           [18, "Alan"],
           [28, "Glory"],
           [18, "Popeye"],
           [28, "Alan"]);
@table2 = (["Jonah", "Whales"],
           ["Jonah", "Spiders"],
           ["Alan", "Ghosts"],
           ["Alan", "Zombies"],
           ["Glory", "Buffy"]);

$Data::Dumper::Indent = 0;
foreach my $row (hashJoin(\@table1, 1, \@table2, 0)) {
    print Dumper($row), "\n";
}
