my $sep := '/';
my @dirs := </home/user1/tmp/coverage/test
             /home/user1/tmp/covert/operator
             /home/user1/tmp/coven/members>;

my @comps := @dirs.map: { [ .comb(/ $sep [ <!before $sep> . ]* /) ] };

say "The longest common path is ",
    gather for 0..* -> $column {
        last unless all(@comps[*]»[$column]) eq @comps[0][$column];
        take @comps[0][$column] // last;
    }
