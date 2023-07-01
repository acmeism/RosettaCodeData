use MONKEY-SEE-NO-EVAL;

sub a ($p) { print 'a'; $p }
sub b ($p) { print 'b'; $p }

for 1, 0 X 1, 0 -> ($p, $q) {
    for '&&', '||' -> $op {
        my $s = "a($p) $op b($q)";
        print "$s: ";
        EVAL $s;
        print "\n";
    }
}
