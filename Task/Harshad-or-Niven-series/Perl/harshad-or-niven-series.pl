use v5.36;
use List::Util 'sum';

sub createHarshads ($limit) {
    my(@harshads,$number);
    do {
        $number++;
        if ( $number % sum ( split ( // , $number ) ) == 0 ) {
	        push @harshads , $number;
        }
    } until $harshads[ -1 ] > $limit;
    return @harshads;
}

my @harshadnumbers = createHarshads my $limit = 1000;
say "@harshadnumbers[0..19]";
say "The first Harshad number greater than $limit is $harshadnumbers[ -1 ]!" ;
