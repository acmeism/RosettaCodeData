my @square-and-cube = map { .⁶ }, 1..Inf;

my @square-but-not-cube = (1..Inf).map({ .² }).grep({ $_ ∉ @square-and-cube[^@square-and-cube.first: * > $_, :k]});

put "First 30 positive integers that are a square but not a cube: \n",  @square-but-not-cube[^30];

put "\nFirst 15 positive integers that are both a square and a cube: \n", @square-and-cube[^15];
