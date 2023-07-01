use ntheory:from<Perl5> <factor is_prime>;

sub zumkeller ($range)  {
    $range.grep: -> $maybe {
        next if $maybe < 3 or $maybe.&is_prime;
        my @divisors = $maybe.&factor.combinations».reduce( &[×] ).unique.reverse;
        next unless [and] @divisors > 2, @divisors %% 2, (my $sum = @divisors.sum) %% 2, ($sum /= 2) ≥ $maybe;
        my $zumkeller = False;
        if $maybe % 2 {
            $zumkeller = True
        } else {
            TEST: for 1 ..^ @divisors/2 -> $c {
                @divisors.combinations($c).map: -> $d {
                    next if $d.sum != $sum;
                    $zumkeller = True and last TEST
                }
            }
        }
        $zumkeller
    }
}

say "First 220 Zumkeller numbers:\n" ~
    zumkeller(^Inf)[^220].rotor(20)».fmt('%3d').join: "\n";

put "\nFirst 40 odd Zumkeller numbers:\n" ~
    zumkeller((^Inf).map: * × 2 + 1)[^40].rotor(10)».fmt('%7d').join: "\n";

# Stretch. Slow to calculate. (minutes)
put "\nFirst 40 odd Zumkeller numbers not divisible by 5:\n" ~
    zumkeller(flat (^Inf).map: {my \p = 10 * $_; p+1, p+3, p+7, p+9} )[^40].rotor(10)».fmt('%7d').join: "\n";
