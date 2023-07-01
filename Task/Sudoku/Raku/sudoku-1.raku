my @A = <
    5 3 0  0 2 4  7 0 0
    0 0 2  0 0 0  8 0 0
    1 0 0  7 0 3  9 0 2

    0 0 8  0 7 2  0 4 9
    0 2 0  9 8 0  0 7 0
    7 9 0  0 0 0  0 8 0

    0 0 0  0 3 0  5 0 6
    9 6 0  0 1 0  3 0 0
    0 5 0  6 9 0  0 1 0
>;

my &I = * div 9;  # line number
my &J = * % 9;    # column number
my &K = { ($_ div 27) * 3 + $_ % 9 div 3 }; # bloc number

sub solve {
    for ^@A -> $i {
	next if @A[$i];
	my @taken-values = @A[
	    grep {
		I($_) == I($i) || J($_) == J($i) || K($_) == K($i)
	    }, ^@A
	];
	for grep none(@taken-values), 1..9 {
	    @A[$i] = $_;
	    solve;
	}
	return @A[$i] = 0;
    }
    my $i = 1;
    for ^@A {
	print "@A[$_] ";
	print " "  if $i %% 3;
	print "\n" if $i %% 9;
	print "\n" if $i++ %% 27;
    }
}
solve;
