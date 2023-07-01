my %*SUB-MAIN-OPTS = :named-anywhere;

unit sub MAIN ( $dict = 'unixdict.txt', :$min-chars = 3, :$mono = False );

my %words;
$dict.IO.slurp.words.map: { .chars < $min-chars ?? (next) !! %words{.uc.comb.sort.join}.push: .uc };

my @teacups;
my %seen;

for %words.values -> @these {
    next if !$mono && @these < 2;
    MAYBE: for @these {
        my $maybe = $_;
        next if %seen{$_};
        my @print;
        for ^$maybe.chars {
            if $maybe ∈ @these {
                @print.push: $maybe;
                $maybe = $maybe.comb.list.rotate.join;
            } else {
                @print = ();
                next MAYBE
            }
        }
        if @print.elems {
            @teacups.push: @print;
            %seen{$_}++ for @print;
        }
    }
}

say .unique.join(", ") for sort @teacups;
