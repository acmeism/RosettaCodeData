# Extend a matrix in 2 dimensions based on 3 neighbors.
sub grow-matrix(@matrix, &func) {
    my $n = @matrix.shape eq '*' ?? 1 !! @matrix.shape[0];
    my @m[$n+1;$n+1];
    for ^$n X ^$n -> ($i, $j) {
       @m[$i;$j] = @matrix[$i;$j];
    }
#                     West         North        NorthWest
    @m[$n; 0] = func( 0,           @m[$n-1;0],  0            );
    @m[ 0;$n] = func( @m[0;$n-1],  0,           0            );
    @m[$_;$n] = func( @m[$_;$n-1], @m[$_-1;$n], @m[$_-1;$n-1]) for 1 ..^ $n;
    @m[$n;$_] = func( @m[$n;$_-1], @m[$n-1;$_], @m[$n-1;$_-1]) for 1 ..  $n;
    @m;
}

# I am but mad north-northwest...
sub madd-n-nw(@m) { grow-matrix @m, -> $w, $n, $nw {  $n + $nw } }
sub madd-w-nw(@m) { grow-matrix @m, -> $w, $n, $nw {  $w + $nw } }
sub madd-w-n (@m) { grow-matrix @m, -> $w, $n, $nw {  $w + $n  } }

# Define 3 infinite sequences of Pascal matrices.
constant upper-tri = [1], &madd-w-nw ... *;
constant lower-tri = [1], &madd-n-nw ... *;
constant symmetric = [1], &madd-w-n  ... *;

show_m upper-tri[4];
show_m lower-tri[4];
show_m symmetric[4];

sub show_m (@m) {
my \n = @m.shape[0];
for ^n X ^n -> (\i, \j) {
    print @m[i;j].fmt("%{1+max(@m).chars}d");
    print "\n" if j+1 eq n;
}
say '';
}
