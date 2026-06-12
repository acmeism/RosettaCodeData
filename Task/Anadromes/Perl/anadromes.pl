use strict;
use warnings;

my(%W,%A);
for my $w ( grep { /[A-z\-]{7,}/ } split "\n", do { local( @ARGV, $/ ) = ( 'words.txt' ); <> } ) {
    my $r = reverse $w;
    if ($W{$r}) { $A{$r} = sprintf "%10s ↔ %s\n", $r, $w }
    else        { $W{$w} = $w                            }
}

print $A{$_} for sort keys %A;
