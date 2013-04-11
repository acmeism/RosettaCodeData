grammar BalBrack {
    token TOP { ^ <balanced>* $ };
    token balanced { '[' <balanced>* ']' }
}

my $n = prompt "Number of bracket pairs: ";
my $s = (<[ ]> xx $n).pick(*).join;
say "$s { BalBrack.parse($s) ?? "is" !! "is not" } well-balanced";
