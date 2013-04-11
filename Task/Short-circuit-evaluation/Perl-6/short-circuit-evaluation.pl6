sub a ($p) { print 'a'; $p }
sub b ($p) { print 'b'; $p }

for '&&', '||' -> $op {
    for True, False X True, False -> $p, $q {
        my $s = "a($p) $op b($q)";
        print "$s: ";
        eval $s;
        print "\n";
    }
}
