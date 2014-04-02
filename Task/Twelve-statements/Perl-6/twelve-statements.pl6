sub infix:<→> ($protasis,$apodosis) { !$protasis or $apodosis }

my @tests = { True },  # (there's no 0th statement)
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
    { 4 == [+] .[1..11] };

my @good;
my @bad;
my @ugly;

for reverse 0 ..^ 2**12 -> $i {
    my @b = $i.fmt("%012b").comb;
    my @assert = True, @b.map: { .so }
    my @result = @tests.map: { .(@assert).so }
    my @s = ( $_ if $_ and @assert[$_] for 1..12 );
    if @result eqv @assert {
	push @good, "<{@s}> is consistent.";
    }
    else {
	my @cons = gather for 1..12 {
	    if @assert[$_] !eqv @result[$_] {
		take @result[$_] ?? $_ !! "¬$_";
	    }
	}
	my $mess = "<{@s}> implies {@cons}.";
	if @cons == 1 { push @bad, $mess } else { push @ugly, $mess }
    }
}

.say for @good;
say "\nNear misses:";
.say for @bad;
