use List::Util 'uniq';

sub countabc {
    my @l = qw{a b c};
    my %c = map { $_ => 0 } @l;
    $c{$_}++ for split //, shift =~ s/[^@l]//gr;
    return (uniq values %c) == 1;
}
