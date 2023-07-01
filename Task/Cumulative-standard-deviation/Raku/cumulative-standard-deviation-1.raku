sub sd (@a) {
    my $mean = @a R/ [+] @a;
    sqrt @a R/ [+] map (* - $mean)², @a;
}

sub sdaccum {
    my @a;
    return { push @a, $^x; sd @a; };
}

my &f = sdaccum;
say f $_ for 2, 4, 4, 4, 5, 5, 7, 9;
