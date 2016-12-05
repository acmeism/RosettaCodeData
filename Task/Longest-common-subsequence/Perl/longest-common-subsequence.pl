sub lcs {
    my ($a, $b) = @_;
    if (!length($a) || !length($b)) {
        return "";
    }
    if (substr($a, 0, 1) eq substr($b, 0, 1)) {
        return substr($a, 0, 1) . lcs(substr($a, 1), substr($b, 1));
    }
    my $c = lcs(substr($a, 1), $b) || "";
    my $d = lcs($a, substr($b, 1)) || "";
    return length($c) > length($d) ? $c : $d;
}

print lcs("thisisatest", "testing123testing") . "\n";
