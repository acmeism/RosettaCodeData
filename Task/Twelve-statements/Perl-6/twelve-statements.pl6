sub infix:<→> ($protasis, $apodosis) { !$protasis or $apodosis }

my @tests =
    { .end == 12 and all(.[1..12]) === any(True, False) },
    { 3 == [+] .[7..12] },
    { 2 == [+] .[2,4...12] },
    { .[5] → all .[6,7] },
    { none .[2,3,4] },
    { 4 == [+] .[1,3...11] },
    { one .[2,3] },
    { .[7] → all .[5,6] },
    { 3 == [+] .[1..6] },
    { all .[11,12] },
    { one .[7,8,9] },
    { 4 == [+] .[1..11] },
;

my @solutions;
my @misses;

for [X] (True, False) xx 12 {
    my @assert = Nil, |$_;
    my @result = Nil, |@tests.map({ ?.(@assert) });
    my @true = @assert.grep(?*, :k);
    my @cons = (@assert Z=== @result).grep(!*, :k);
    given @cons {
        when 0 { push @solutions, "<{@true}> is consistent."; }
        when 1 { push @misses, "<{@true}> implies { "¬" if !@result[~$_] }$_." }
    }
}

.say for @solutions;
say "";
say "Near misses:";
.say for @misses;
