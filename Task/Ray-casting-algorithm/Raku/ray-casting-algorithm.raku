constant ε = 0.0001;

sub ray-hits-seg([\Px,\Py], [[\Ax,\Ay], [\Bx,\By]] --> Bool) {
    Py += ε if Py == Ay | By;

    if Py < Ay or Py > By or Px > (Ax max Bx) {
	False;
    }
    elsif Px < (Ax min Bx) {
	True;
    }
    else {
	my \red  = Ax == Bx ?? Inf !! (By - Ay) / (Bx - Ax);
	my \blue = Ax == Px ?? Inf !! (Py - Ay) / (Px - Ax);
	blue >= red;
    }
}

sub point-in-poly(@point, @polygon --> Bool) {
    so 2 R% [+] gather for @polygon -> @side {
	take ray-hits-seg @point, @side.sort(*.[1]);
    }
}

my %poly =
    squared =>
	 [[[ 0.0,  0.0], [10.0,  0.0]],
	  [[10.0,  0.0], [10.0, 10.0]],
	  [[10.0, 10.0], [ 0.0, 10.0]],
	  [[ 0.0, 10.0], [ 0.0,  0.0]]],
    squaredhole =>
	 [[[ 0.0,  0.0], [10.0,  0.0]],
	  [[10.0,  0.0], [10.0, 10.0]],
	  [[10.0, 10.0], [ 0.0, 10.0]],
	  [[ 0.0, 10.0], [ 0.0,  0.0]],
	  [[ 2.5,  2.5], [ 7.5,  2.5]],
	  [[ 7.5,  2.5], [ 7.5,  7.5]],
	  [[ 7.5,  7.5], [ 2.5,  7.5]],
	  [[ 2.5,  7.5], [ 2.5,  2.5]]],
    strange =>
	 [[[ 0.0,  0.0], [ 2.5,  2.5]],
	  [[ 2.5,  2.5], [ 0.0, 10.0]],
	  [[ 0.0, 10.0], [ 2.5,  7.5]],
	  [[ 2.5,  7.5], [ 7.5,  7.5]],
	  [[ 7.5,  7.5], [10.0, 10.0]],
	  [[10.0, 10.0], [10.0,  0.0]],
	  [[10.0,  0.0], [ 2.5,  2.5]],
	  [[ 2.5,  2.5], [ 0.0,  0.0]]],  # conjecturally close polygon
    exagon =>
	 [[[ 3.0,  0.0], [ 7.0,  0.0]],
	  [[ 7.0,  0.0], [10.0,  5.0]],
	  [[10.0,  5.0], [ 7.0, 10.0]],
	  [[ 7.0, 10.0], [ 3.0, 10.0]],
	  [[ 3.0, 10.0], [ 0.0,  5.0]],
	  [[ 0.0,  5.0], [ 3.0,  0.0]]];

my @test-points =
	  [  5.0,  5.0],
	  [  5.0,  8.0],
	  [-10.0,  5.0],
	  [  0.0,  5.0],
	  [ 10.0,  5.0],
	  [  8.0,  5.0],
	  [ 10.0, 10.0];

for <squared squaredhole strange exagon> -> $polywanna {
    say "$polywanna";
    my @poly = %poly{$polywanna}[];
    for @test-points -> @point {
	say "\t(@point.fmt('%.1f',','))\t{ point-in-poly(@point, @poly) ?? 'IN' !! 'OUT' }";
    }
}
