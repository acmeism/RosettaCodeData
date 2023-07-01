sub deconvolve (@g, @f) {
    my \h = 1 + @g - @f;
    my @m;
    @m[^@g;^h] »+=» 0;
    @m[^@g; h] »=«  @g;
    for ^h -> \j { for @f.kv -> \k, \v { @m[j+k;j] = v } }
    (rref @m)[^h;h]
}

sub convolve (@f, @h) {
    my @g = 0 xx + @f + @h - 1;
    @g[^@f X+ ^@h] »+=« (@f X× @h);
    @g
}

# Reduced Row Echelon Form simultaneous equation solver
# Can handle over-specified systems of equations (N unknowns in N + M equations)
sub rref (@m) {
    @m = trim-system @m;
    my ($lead, $rows, $cols) = 0, @m, @m[0];
    for ^$rows -> $r {
        return @m unless $lead < $cols;
        my $i = $r;
        until @m[$i;$lead] {
            next unless ++$i == $rows;
            $i = $r;
            return @m if ++$lead == $cols;
        }
        @m[$i, $r] = @m[$r, $i] if $r != $i;
        @m[$r] »/=» $ = @m[$r;$lead];
        for ^$rows -> $n {
            next if $n == $r;
            @m[$n] »-=» @m[$r] »×» (@m[$n;$lead] // 0);
        }
        ++$lead;
    }
    @m
 }

# Reduce to N equations in N unknowns; a no-op unless rows > cols
sub trim-system (@m) {
    return @m unless @m ≥ @m[0];
    my (\vars, @t) = @m[0] - 1;
    for ^vars -> \lead {
        for ^@m -> \row {
            @t.append: @m.splice(row, 1) and last if @m[row;lead];
        }
    }
    while @t < vars and @m { @t.push: shift @m }
    @t
}

my @h = (-8,-9,-3,-1,-6,7);
my @f = (-3,-6,-1,8,-6,3,-1,-9,-9,3,-2,5,2,-2,-7,-1);
my @g = (24,75,71,-34,3,22,-45,23,245,25,52,25,-67,-96,96,31,55,36,29,-43,-7);

.say for ~@g,   ~convolve(@f, @h),'';
.say for ~@h, ~deconvolve(@g, @f),'';
.say for ~@f, ~deconvolve(@g, @h),'';
