multi infix:<rad> ()       { 0 }
multi infix:<rad> ($a)     { $a }
multi infix:<rad> ($a, $b) { $a * $*RADIX + $b }

multi expand(Int $n is copy, 1) { $n }
multi expand(Int $n is copy, Int $*RADIX) {
    my \RAD = $*RADIX;

    my @reversed-digits = gather while $n > 0 {
	take $n % RAD;
	$n div= RAD;
    }

    eager for ^RAD {
	[rad] reverse @reversed-digits[$_, * + RAD ... *]
    }
}

multi compress(@n where @n == 1) { @n[0] }
multi compress(@n is copy) {
    my \RAD = my $*RADIX = @n.elems;

    [rad] reverse gather while @n.any > 0 {
	    (state $i = 0) %= RAD;
	    take @n[$i] % RAD;
	    @n[$i] div= RAD;
	    $i++;
	}
}

sub rank(@n) { compress (compress(@n), @n - 1)}
sub unrank(Int $n) { my ($a, $b) = expand $n, 2; expand $a, $b + 1 }

my @list = (^10).roll((2..20).pick);
my $rank = rank @list;
say "[$@list] -> $rank -> [{unrank $rank}]";

for ^10 {
    my @unrank = unrank $_;
    say "$_ -> [$@unrank] -> {rank @unrank}";
}
