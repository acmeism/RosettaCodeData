#!/usr/bin/perl

sub truth_table {
    my $s = shift;
    my (%seen, @vars);
    for ($s =~ /([a-zA-Z_]\w*)/g) {
        $seen{$_} //= do { push @vars, $_; 1 };
    }

    print "\n", join("\t", @vars, $s), "\n", '-' x 40, "\n";
    @vars = map("\$$_", @vars);

    $s =~ s/([a-zA-Z_]\w*)/\$$1/g;
    $s = "print(".join(',"\t", ', map("($_?'T':'F')", @vars, $s)).",\"\\n\")";
    $s = "for my $_ (0, 1) { $s }" for (reverse @vars);
    eval $s;
}

truth_table 'A ^ A_1';
truth_table 'foo & bar | baz';
truth_table 'Jim & (Spock ^ Bones) | Scotty';
