sub balanced($s) {
    .none < 0 and .[*-1] == 0
        given [\+] '\\' «leg« $s.comb;
}

my $n = prompt "Number of bracket pairs: ";
my $s = <[ ]>.roll($n*2).join;
say "$s { balanced($s) ?? "is" !! "is not" } well-balanced"
