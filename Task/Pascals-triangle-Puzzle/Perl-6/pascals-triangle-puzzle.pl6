# set up triangle
my $rows = 5;
my @tri = (1..$rows).map: { [ { x => 0, z => 0, v => 0, rhs => Nil } xx $_ ] }
@tri[0][0]<rhs> = 151;
@tri[2][0]<rhs> = 40;
@tri[4][0]<x> = 1;
@tri[4][1]<v> = 11;
@tri[4][2]<x> = 1;
@tri[4][2]<z> = 1;
@tri[4][3]<v> = 4;
@tri[4][4]<z> = 1;

# aggregate from bottom to top
for @tri - 2 ... 0 -> $row {
    for 0 ..^ @tri[$row] -> $col {
        @tri[$row][$col]{$_} = @tri[$row+1][$col]{$_} + @tri[$row+1][$col+1]{$_} for 'x','z','v';
    }
}

# find equations
my @eqn = gather for @tri -> $row {
    for @$row -> $cell {
        take [ $cell<x>, $cell<z>, $cell<rhs> - $cell<v> ] if defined $cell<rhs>;
    }
}

# print equations
say "Equations:";
say "  x +   z = y";
for @eqn -> [$x,$z,$y] { say "$x x + $z z = $y" }

# solve
my $f = @eqn[0][1] / @eqn[1][1];
@eqn[0][$_] -=  $f * @eqn[1][$_] for 0..2;
$f = @eqn[1][0] / @eqn[0][0];
@eqn[1][$_] -=  $f * @eqn[0][$_] for 0..2;

# print solution
say "Solution:";
my $x = @eqn[0][2] / @eqn[0][0];
my $z = @eqn[1][2] / @eqn[1][1];
my $y = $x + $z;
say "x=$x, y=$y, z=$z";
