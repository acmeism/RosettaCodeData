package SSL_Node;
use strict;
use Class::Tiny qw( val next );

sub BUILD {
    my $self = shift;
    exists($self->{val}) or die "Must supply 'val'";
    if (exists $self->{next}) {
        ref($self->{next}) eq 'SSL_Node'
            or die "If supplied, 'next' must be an SSL_Node";
    }
    return;
}

package main;
use strict;
# Construct an example list,
my @vals = 1 .. 10;
my $countdown = SSL_Node->new(val => shift(@vals));
while (@vals) {
    my $head = SSL_Node->new(val => shift(@vals), next => $countdown);
    $countdown = $head;
}
# ...then traverse it.
my $node = $countdown;
while ($node) {
    print $node->val, "... ";
    $node = $node->next;
}
print "\n";
