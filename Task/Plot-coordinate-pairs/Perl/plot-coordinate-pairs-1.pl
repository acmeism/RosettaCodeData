use GD::Graph::points;

@data = (
  [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
  [2.7, 2.8, 31.4, 38.1, 58.0, 76.2, 100.5, 130.0, 149.3, 180.0],
);

$graph = GD::Graph::points->new(400, 300);
open my $fh, '>', "qsort-range-10-9.png";
binmode $fh;
print $fh $graph->plot(\@data)->png;
close $fh;
