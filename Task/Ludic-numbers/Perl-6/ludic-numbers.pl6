constant ludic = gather {
        my @taken = take 1;
        my @rotor;

        for 2..* -> $i {
            loop (my $j = 0; $j < @rotor; $j++) {
                --@rotor[$j] or last;
            }
            if $j < @rotor {
                @rotor[$j] = @taken[$j+1];
            }
            else {
                push @taken, take $i;
                push @rotor, @taken[$j+1];
            }
        }
    }

say ludic[^25];
say "Number of Ludic numbers <= 1000: ", +(ludic ...^ * > 1000);
say "Ludic numbers 2000..2005: ", ludic[1999..2004];

my \l250 = set ludic ...^ * > 250;
say "Ludic triples < 250: ", gather
    for l250.keys -> $a {
        my $b = $a + 2;
        my $c = $a + 6;
        take "<$a $b $c>" if $b ∈ l250 and $c ∈ l250;
    }
