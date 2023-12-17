# For all positive integers from 1 to Infinity
for 1 .. Inf -> $integer {

    # calculate the square of the integer
    my $square = $integer²;

    # print the integer and square and exit if the square modulo 1000000 is equal to 269696
    print "{$integer}² equals $square" and exit if $square mod 1000000 == 269696;
}
