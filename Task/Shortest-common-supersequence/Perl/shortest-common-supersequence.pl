sub lcs { # longest common subsequence
    my( $u, $v ) = @_;
    return '' unless length($u) and length($v);
    my $longest = '';
    for my $first ( 0..length($u)-1 ) {
        my $char = substr $u, $first, 1;
        my $i = index( $v, $char );
        next if -1==$i;
        my $next = $char;
        $next .= lcs( substr( $u, $first+1), substr( $v, $i+1 ) ) unless $i==length($v)-1;
        $longest = $next if length($next) > length($longest);
    }
    return $longest;
}

sub scs { # shortest common supersequence
    my( $u, $v ) = @_;
    my @lcs = split //, lcs $u, $v;
    my $pat = "(.*)".join("(.*)",@lcs)."(.*)";
    my @u = $u =~ /$pat/;
    my @v = $v =~ /$pat/;
    my $scs = shift(@u).shift(@v);
    $scs .= $_.shift(@u).shift(@v) for @lcs;
    return $scs;
}

my $u = "abcbdab";
my $v = "bdcaba";
printf "Strings %s %s\n", $u, $v;
printf "Longest common subsequence:   %s\n", lcs $u, $v;
printf "Shortest common supersquence: %s\n", scs $u, $v;
