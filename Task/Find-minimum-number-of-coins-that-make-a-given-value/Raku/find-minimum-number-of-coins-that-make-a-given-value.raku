my @denominations = 200, 100, 50, 20, 10, 5, 2, 1;

sub change (Int $n is copy where * >= 0) { gather for @denominations { take $n div $_; $n %= $_ } }

for 988, 1307, 37511, 0 -> $amount {
    say "\n$amount:";
    printf "%d × %d\n", |$_ for $amount.&change Z @denominations;
}
