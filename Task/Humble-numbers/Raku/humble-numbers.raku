sub smooth-numbers (*@list) {
    cache my \Smooth := gather {
        my %i = (flat @list) Z=> (Smooth.iterator for ^@list);
        my %n = (flat @list) Z=> 1 xx *;

        loop {
            take my $n := %n{*}.min;

            for @list -> \k {
                %n{k} = %i{k}.pull-one * k if %n{k} == $n;
            }
        }
    }
}

my $humble := smooth-numbers(2,3,5,7);

put $humble[^50];
say '';

my $upto = 50;
my $digits = 1;
my $count;

$humble.map: -> \h {
    ++$count and next if h.chars == $digits;
    printf "Digits: %2d - Count: %s\n", $digits++, $count;
    $count = 1;
    last if $digits > $upto;
}
