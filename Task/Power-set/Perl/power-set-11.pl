use strict;
use warnings;
sub powerset :prototype(&@) {
    my $callback = shift;
    my $bitmask = '';
    my $bytes = @_/8;
    {
       my @indices = grep vec($bitmask, $_, 1), 0..$#_;
       $callback->( @_[@indices] );
       ++vec($bitmask, $_, 8) and last for 0 .. $bytes;
       redo if @indices != @_;
    }
}

print "powerset of empty set:\n";
powerset { print "[@_]\n" };
print "powerset of set {1,2,3,4}:\n";
powerset { print "[@_]\n" } 1..4;
my $i = 0;
powerset { ++$i } 1..9;
print "The powerset of a nine element set contains $i elements.\n";
