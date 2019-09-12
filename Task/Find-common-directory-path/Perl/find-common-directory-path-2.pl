use List::Util qw(first);

sub common_prefix {
    my ($sep, @paths) = @_;
    my %prefixes;

    for (@paths) {
        do { ++$prefixes{$_} } while s/$sep [^$sep]* $//x
    }

    return first { $prefixes{$_} == @paths } reverse sort keys %prefixes;
}
