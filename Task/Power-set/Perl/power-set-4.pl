use Set::Object qw(set);

sub powerset {
    my $p = Set::Object->new( set() );
    foreach my $i (shift->elements) {
        $p->insert( map { set($_->elements, $i) } $p->elements );
    }
    return $p;
}

my $set = set(1, 2, 3);
my $powerset = powerset($set);

print $powerset->as_string, "\n";
