use List::Util qw(first);

sub common_prefix {
    my ($sep, @paths) = @_;
    my %prefixes;

    foreach (@paths) {
        do { ++$prefixes{$_} } while s/$sep [^$sep]* $//g
    }

    return first { $prefixes{$_} == @paths } reverse sort keys %prefixes;
}
