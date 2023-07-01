constant @factorial = 1, |[\*] 1..*;

constant $limit = 1500000;

constant $bases = 9 .. 12;

my @result;

$bases.map: -> $base {

    @result[$base] = "\nFactorions in base $base:\n1 2";

    sink (1 .. $limit div $base).map: -> $i {
        my $product = $i * $base;
        my $partial;

        for $i.polymod($base xx *) {
            $partial += @factorial[$_];
            last if $partial > $product
        }

        next if $partial > $product;

        my $sum;

        for ^$base {
            last if ($sum = $partial + @factorial[$_]) > $product + $_;
            @result[$base] ~= " $sum" and last if $sum == $product + $_
        }
    }
}

.say for @result[$bases];
