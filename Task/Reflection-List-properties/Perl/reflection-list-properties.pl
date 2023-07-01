{
     package Point;
     use Class::Spiffy -base;

     field 'x';
     field 'y';
}

{
     package Circle;
     use base qw(Point);
     field 'r';
}

my $p1 = Point->new(x => 8, y => -5);
my $c1 = Circle->new(r => 4);
my $c2 = Circle->new(x => 1, y => 2, r => 3);

use Data::Dumper;
say Dumper $p1;
say Dumper $c1;
say Dumper $c2;
