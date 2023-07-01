use List::Util qw(sum0 max);

sub comb {
    my ($s, $n) = @_;
    $n || return (1);
    my @r = (0) x ($n - max(@$s) + 1);
    my @c = comb($s, $n - 1);
    foreach my $i (0 .. $#c) {
        $c[$i] || next;
        foreach my $k (@$s) {
            $r[$i + $k] += $c[$i];
        }
    }
    return @r;
}

sub winning {
    my ($s1, $n1, $s2, $n2) = @_;

    my @p1 = comb($s1, $n1);
    my @p2 = comb($s2, $n2);

    my ($win, $loss, $tie) = (0, 0, 0);

    foreach my $i (0 .. $#p1) {
        $win  += $p1[$i] * sum0(@p2[0    .. $i - 1]);
        $tie  += $p1[$i] * sum0(@p2[$i   .. $i    ]);
        $loss += $p1[$i] * sum0(@p2[$i+1 .. $#p2  ]);
    }
    my $total = sum0(@p1) * sum0(@p2);
    map { $_ / $total } ($win, $tie, $loss);
}

print '(', join(', ', winning([1 ..  4], 9, [1 .. 6], 6)), ")\n";
print '(', join(', ', winning([1 .. 10], 5, [1 .. 7], 6)), ")\n";
