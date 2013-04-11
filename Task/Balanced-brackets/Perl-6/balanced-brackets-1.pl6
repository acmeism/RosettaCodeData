sub balanced($s) {
    my $l = 0;
    for $s.comb {
        when "]" {
            --$l;
            return False if $l < 0;
        }
        when "[" {
            ++$l;
        }
    }
    return $l == 0;
}

my $n = prompt "Number of brackets";
my $s = (<[ ]> xx $n).pick(*).join;
say "$s {balanced($s) ?? "is" !! "is not"} well-balanced"
