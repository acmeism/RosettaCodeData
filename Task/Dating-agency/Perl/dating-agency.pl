use strict;
use warnings;

use Digest::SHA qw(sha1_hex);
use List::Util <max head>;

my(%laddies,%taylors);

for my $name ( qw( Adam Bob Conrad Drew Eddie Fred George Harry Ian Jake Ken Larry Mike
                   Ned Oscar Peter Quincy Richard Sam Tom Uriah Victor Will Yogi Zach ) ) {
    $laddies{$name}{loves}   = hex substr sha1_hex($name),  0, 4;
    $laddies{$name}{lovable} = hex substr sha1_hex($name), -4, 4;
}

for my $name ( < Elizabeth Swift Rip > ) {
    $taylors{$name}{loves}   = hex substr sha1_hex($name),  0, 4;
    $taylors{$name}{lovable} = hex substr sha1_hex($name), -4, 4;
}

sub rank_by {
   my($subk,$k,$t,$l) = @_;
   sort { abs $$t{$k}{$subk} - $$l{$a}{$subk} <=> abs $$t{$k}{$subk} - $$l{$b}{$subk} } keys %$l;
}

for my $taylor (sort keys %taylors) {
    printf "%9s will like: %s\n", $taylor, join ', ', my @likes = head 10, rank_by('loves',  $taylor, \%taylors, \%laddies);
    printf "        Is liked by: %s\n",    join ', ', my @liked = head 10, rank_by('lovable',$taylor, \%taylors, \%laddies);

    my($max,%matches) = 0;
    $matches{$liked[$_]}  = @liked-$_ for reverse 0..$#liked;
    $matches{$likes[$_]} += @likes-$_ for reverse 0..$#likes;
    $matches{$_} < $max or $max = $matches{$_} for keys %matches;
    print 'Best match(s): ' . join(', ', sort grep { $matches{$_} == $max } keys %matches) . "\n\n";
}
