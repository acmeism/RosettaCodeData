sub palin(Str $s --> Bool) {
    my @chars = $s.lc.comb(/\w/);
    while @chars > 1 {
        return False unless @chars.shift eq @chars.pop;
    }
    return True;
}

my @tests =
    "A man, a plan, a canal: Panama.",
    "My dog has fleas",
    "Madam, I'm Adam.",
    "1 on 1",
    "In girum imus nocte et consumimur igni";

for @tests { say (palin($_) ?? "Yes" !! "No"),"\t",$_ };
