my $sep = '/';
my @dirs = </home/user1/tmp/coverage/test
            /home/user1/tmp/covert/operator
            /home/user1/tmp/coven/members>;

my @comps = @dirs.map: { [ .comb(/ $sep [ <!before $sep> . ]* /) ] };

my $prefix = '';

while all(@comps[*]»[0]) eq @comps[0][0] {
    $prefix ~= @comps[0][0] // last;
    @comps».shift;
}

say "The longest common path is $prefix";
