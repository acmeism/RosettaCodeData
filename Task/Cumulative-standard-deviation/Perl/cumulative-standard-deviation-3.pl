# <(x - <x>)²> = <x²> - <x>²
{
    my $num, $sum, $sum2;
    sub stddev {
	my $x = shift;
	$num++;
	return sqrt(
	    ($sum2 += $x**2) / $num -
	    (($sum += $x) / $num)**2
	);
    }
}

print stddev($_), "\n" for qw(2 4 4 4 5 5 7 9);
