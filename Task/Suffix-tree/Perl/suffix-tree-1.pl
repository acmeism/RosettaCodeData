use strict;
use warnings;
use Data::Dumper;

sub classify {
    my $h = {};
    for (@_) { push @{$h->{substr($_,0,1)}}, $_ }
    return $h;
}
sub suffixes {
    my $str = shift;
    map { substr $str, $_ } 0 .. length($str) - 1;
}
sub suffix_tree {
    return +{} if @_ == 0;
    return +{ $_[0] => +{} } if @_ == 1;
    my $h = {};
    my $classif = classify @_;
    for my $key (keys %$classif) {
        my $subtree = suffix_tree(
            map { substr $_, 1 } @{$classif->{$key}}
        );
        my @subkeys = keys %$subtree;
        if (@subkeys == 1) {
            my ($subkey) = @subkeys;
            $h->{"$key$subkey"} = $subtree->{$subkey};
        } else { $h->{$key} = $subtree }
    }
    return $h;
}
print +Dumper suffix_tree suffixes 'banana$';
