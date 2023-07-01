use strict;
use warnings;
use bigint;
sub isEgyption{
    my $nr = int($_[0]);
    my $de = int($_[1]);
    if($nr == 0 or $de == 0){
	#Invalid input
	return;
    }
    if($de % $nr == 0){
	# They divide so print
	printf "1/" . int($de/$nr);
	return;
    }
    if($nr % $de == 0){
	# Invalid fraction
	printf $nr/$de;
	return;
    }
    if($nr > $de){
        printf int($nr/$de) . " + ";
	isEgyption($nr%$de, $de);
	return;
    }
    # Floor to find ceiling and print as fraction
    my $tmp = int($de/$nr) + 1;
    printf "1/" . $tmp . " + ";
    isEgyption($nr*$tmp-$de, $de*$tmp);
}

my $nrI = 2014;
my $deI = 59;
printf "\nEgyptian Fraction Representation of " . $nrI . "/" . $deI . " is: \n\n";
isEgyption($nrI,$deI);
