# Deconvolution of N dimensional matrices.
sub deconvolve-N ( @g, @f ) {
    my @hsize = @g.shape »-« @f.shape »+» 1;

    my @toSolve = coords(@g.shape).map:
      { [row(@g, @f, $^coords, @hsize)] };

    my @solved = rref( @toSolve );

    my @h;
    for flat coords(@hsize) Z @solved[*;*-1] -> $_, $v {
        @h.AT-POS(|$_) = $v;
    }
    @h
}

# Construct a row for each value in @g to be sent to the simultaneous equation solver
sub row ( @g, @f, @gcoord, $hsize ) {
    my @row;
    @gcoord = @gcoord[(^@f.shape)]; # clip extraneous values
    for coords( $hsize ) -> @hc {
        my @fcoord;
        for ^@hc -> $i {
            my $window = @gcoord[$i] - @hc[$i];
            @fcoord.push($window) and next if 0 ≤ $window < @f.shape[$i];
            last;
        }
        @row.push: @fcoord == @hc ?? @f.AT-POS(|@fcoord) !! 0;
    }
    @row.push: @g.AT-POS(|@gcoord);
    @row
}

# Constructs an AoA of coordinates to all elements of N dimensional array
sub coords ( @dim ) {
    @[reverse $_ for [X] ([^$_] for reverse @dim)]
}

# Reduced Row Echelon Form simultaneous equation solver
# Can handle over-specified systems (N unknowns in N + M equations)
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

# Pretty printer for N dimensional arrays
# Assumes if first element in level is an array, then all are
sub pretty-print ( @array, $indent = 0 ) {
    if @array[0] ~~ Array {
        say ' ' x $indent,"[";
        pretty-print( $_, $indent + 2 ) for @array;
        say ' ' x $indent, "]{$indent??','!!''}";
    } else {
        say ' ' x $indent, "[{say_it(@array)} ]{$indent??','!!''}";
    }

    sub say_it ( @array ) { return join ",", @array».fmt("%4s"); }
}

my @f[3;2;3] = (
  [
    [ -9,  5, -8 ],
    [  3,  5,  1 ],
  ],
  [
    [ -1, -7,  2 ],
    [ -5, -6,  6 ],
  ],
  [
    [  8,  5,  8 ],
    [ -2, -6, -4 ],
  ]
);

my @g[4;4;6] = (
  [
    [  54,  42,  53, -42,  85, -72 ],
    [  45,-170,  94, -36,  48,  73 ],
    [ -39,  65,-112, -16, -78, -72 ],
    [   6, -11,  -6,  62,  49,   8 ],
  ],
  [
    [ -57,  49, -23,  52,-135,  66 ],
    [ -23, 127, -58,  -5,-118,  64 ],
    [  87, -16, 121,  23, -41, -12 ],
    [ -19,  29,  35,-148, -11,  45 ],
  ],
  [
    [ -55,-147,-146, -31,  55,  60 ],
    [ -88, -45, -28,  46, -26,-144 ],
    [ -12,-107, -34, 150, 249,  66 ],
    [  11, -15, -34,  27, -78, -50 ],
  ],
  [
    [  56,  67, 108,   4,   2, -48 ],
    [  58,  67,  89,  32,  32,  -8 ],
    [ -42, -31,-103, -30, -23,  -8 ],
    [   6,   4, -26, -10,  26,  12 ],
  ]
);

say "# {+@f.shape}D array:";
my @h = deconvolve-N( @g, @f );
say "h =";
pretty-print( @h );
my @h-shaped[2;3;4] = @(deconvolve-N( @g, @f ));
my @ff = deconvolve-N( @g, @h-shaped );
say "\nff =";
pretty-print( @ff );
