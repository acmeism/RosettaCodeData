sub count-unrooted-trees(Int $max-branches, Int $max-weight) {
    my @rooted   = 1,1,0 xx $max-weight - 1;
    my @unrooted = 1,1,0 xx $max-weight - 1;

    sub count-trees-with-centroid(Int $radius) {
        sub add-branches(
            Int $branches,        # number of branches to add
            Int $w,               # weight of heaviest branch to add
            Int $weight  is copy, # accumulated weight of tree
            Int $choices is copy, # number of choices so far
        ) {
            $choices *= @rooted[$w];
            for 1 .. $branches -> $b {
                ($weight += $w) <= $max-weight or last;
                @unrooted[$weight] += $choices if $weight > 2*$radius;
                if $b < $branches {
                    @rooted[$weight] += $choices;
                    add-branches($branches - $b, $_, $weight, $choices) for 1 ..^ $w;
                    $choices = $choices * (@rooted[$w] + $b) div ($b + 1);
                }
            }
        }
        add-branches($max-branches, $radius, 1, 1);
    }

    sub count-trees-with-bicentroid(Int $weight) {
        if $weight %% 2 {
            my \halfs = @rooted[$weight div 2];
            @unrooted[$weight] += (halfs * (halfs + 1)) div 2;
        }
    }

    gather {
        take 1;
        for 1 .. $max-weight {
            count-trees-with-centroid($_);
            count-trees-with-bicentroid($_);
            take @unrooted[$_];
        }
    }
}

my constant N = 100;
my @paraffins := count-unrooted-trees(4, N);
say .fmt('%3d'), ': ', @paraffins[$_] for 1 .. 30, N;
