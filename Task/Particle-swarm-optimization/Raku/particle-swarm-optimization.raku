sub pso-init (%y) {
    my $d = @(%y{'min'});
    my $n = %y{'n'};

    %y{'gbval'} = Inf;
    %y{'gbpos'} = [Inf xx $d];
    %y{'bval'}  = [Inf xx $n];
    %y{'bpos'}  = [%y{'min'} xx $n];
    %y{'pos'}   = [%y{'min'} xx $n];
    %y{'vel'}   = [[0 xx $d] xx $n];

    %y;
}

sub pso (&fn, %y) {
    my %p      = %y{'p'};
    my $n      = %y{'n'};
    my $d      = @(%y{'min'});
    my @bpos   = %y{'min'} xx $n;
    my $gbval  = Inf;
    my $rand-g = rand;
    my (@pos, @vel, @v, @gbpos, @bval);

    for 0 ..^ $n -> \j {
        @v[j] = &fn(%y{'pos'}[j]); # evaluate

        # update
        if @v[j] < %y{'bval'}[j] {
            @bpos[j] = %y{'pos'}[j];
            @bval[j] = @v[j];
        } else {
            @bpos[j] = %y{'bpos'}[j];
            @bval[j] = %y{'bval'}[j];
        }
        if @bval[j] < $gbval {
            $gbval = @bval[j];
            @gbpos = |@bpos[j];
        }
    }

    # migrate
    for 0 ..^ $n -> \j {
        my $rand-p = rand;
        my $ok = True;
        for 0 ..^ $d -> \k {
            @vel[j;k] = %p{'ω'} × %y{'vel'}[j;k]
                       + %p{'φ-p'} × $rand-p × (@bpos[j;k] - %y{'pos'}[j;k])
                       + %p{'φ-g'} × $rand-g × (@gbpos[k]  - %y{'pos'}[j;k]);
            @pos[j;k] = %y{'pos'}[j;k] + @vel[j;k];
            $ok = %y{'min'}[k] < @pos[j;k] < %y{'max'}[k] if $ok;
        }
        next if $ok;
        @pos[j;$_] = %y{'min'}[$_] + (%y{'max'}[$_] - %y{'min'}[$_]) × rand for 0 ..^ $d;
    }

    return {gbpos => @gbpos, gbval => $gbval, bpos => @bpos, bval => @bval, pos => @pos, vel => @vel,
            min => %y{'min'}, max => %y{'max'}, p=> %y{'p'}, n => $n}
}

sub report ($function-name, %state) {
    say $function-name;
    say '🌐 best position: ' ~ %state{'gbpos'}.fmt('%.5f');
    say '🌐 best value:    ' ~ %state{'gbval'}.fmt('%.5f');
    say '';
}

sub mccormick (@x) {
    my ($a,$b) = @x;
    sin($a+$b) + ($a-$b)**2 + (1 + 2.5×$b - 1.5×$a)
}

my %state = pso-init( {
    min => [-1.5, -3],
    max => [4, 4],
    n   => 100,
    p   => {ω=> 0, φ-p=> 0.6, φ-g=> 0.3},
} );
%state = pso(&mccormick, %state) for 1 .. 40;
report 'McCormick', %state;

sub michalewicz (@x) {
    my $sum;
    my $m = 10;
    for 1..@x -> $i {
        my $j = @x[$i-1];
        my $k = sin($i × $j**2/π);
        $sum += sin($j) × $k**(2×$m)
    }
    -$sum
}

%state = pso-init( {
    min => [0, 0],
    max => [π, π],
    n   => 1000,
    p   => {ω=> 0.3, φ-p=> 0.3, φ-g=> 0.3},
} );
%state = pso(&michalewicz, %state) for 1 .. 30;
report 'Michalewicz', %state;
