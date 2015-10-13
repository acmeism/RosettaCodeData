sub deconvolve (@g, @f) {
    my $h = 1 + @g - @f;
    my @m;
    @m[^@g;^$h] >>+=>> 0;
    @m[^@g;$h] >>=<< @g;
    for ^$h -> $j { for @f.kv -> $k, $v { @m[$j + $k][$j] = $v } }
    return rref( @m )[^$h;$h];
}

sub convolve (@f, @h) {
    my @g = 0 xx + @f + @h - 1;
    @g[^@f X+ ^@h] >>+=<< (@f X* @h);
    return @g;
}

# Reduced Row Echelon Form simultaneous equation solver.
# Can handle over-specified systems of equations.
# (n unknowns in n + m equations)
sub rref ($m is copy) {
    return unless $m;
    my ($lead, $rows, $cols) = 0, +$m, +$m[0];

    # Trim off over specified rows if they exist.
    # Not strictly necessary, but can save a lot of
    # redundant calculations.
    if $rows >= $cols {
        $m = trim_system($m);
        $rows = +$m;
    }

    for ^$rows -> $r {
        $lead < $cols or return $m;
        my $i = $r;
        until $m[$i][$lead] {
            ++$i == $rows or next;
            $i = $r;
            ++$lead == $cols and return $m;
        }
        $m[$i, $r] = $m[$r, $i] if $r != $i;
        my $lv = $m[$r][$lead];
        $m[$r] >>/=>> $lv;
        for ^$rows -> $n {
            next if $n == $r;
            $m[$n] >>-=>> $m[$r] >>*>> ($m[$n][$lead]//0);
        }
        ++$lead;
    }
    return $m;

    # Reduce a system of equations to n equations with n unknowns.
    # Looks for an equation with a true value for each position.
    # If it can't find one, assumes that it has already taken one
    # and pushes in the first equation it sees. This assumtion
    # will alway be successful except in some cases where an
    # under-specified system has been supplied, in which case,
    # it would not have been able to reduce the system anyway.
    sub trim_system ($m is rw) {
        my ($vars, @t) = +$m[0]-1, ();
        for ^$vars -> $lead {
            for ^$m -> $row {
                @t.push( $m.splice( $row, 1 ) ) and last if $m[$row][$lead];
            }
        }
        while (+@t < $vars) and +$m { @t.push( $m.splice( 0, 1 ) ) };
        return @t;
    }
}


my @h = (-8,-9,-3,-1,-6,7);
my @f = (-3,-6,-1,8,-6,3,-1,-9,-9,3,-2,5,2,-2,-7,-1);
my @g = (24,75,71,-34,3,22,-45,23,245,25,52,25,-67,-96,96,31,55,36,29,-43,-7);


.say for ~@g, ~convolve(@f, @h),'';

.say for ~@h, ~deconvolve(@g, @f),'';

.say for ~@f, ~deconvolve(@g, @h),'';
