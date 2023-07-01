function perpendicular_distance(array $pt, array $line) {
  // Calculate the normalized delta x and y of the line.
  $dx = $line[1][0] - $line[0][0];
  $dy = $line[1][1] - $line[0][1];
  $mag = sqrt($dx * $dx + $dy * $dy);
  if ($mag > 0) {
    $dx /= $mag;
    $dy /= $mag;
  }

  // Calculate dot product, projecting onto normalized direction.
  $pvx = $pt[0] - $line[0][0];
  $pvy = $pt[1] - $line[0][1];
  $pvdot = $dx * $pvx + $dy * $pvy;

  // Scale line direction vector and subtract from pv.
  $dsx = $pvdot * $dx;
  $dsy = $pvdot * $dy;
  $ax = $pvx - $dsx;
  $ay = $pvy - $dsy;

  return sqrt($ax * $ax + $ay * $ay);
}

function ramer_douglas_peucker(array $points, $epsilon) {
  if (count($points) < 2) {
    throw new InvalidArgumentException('Not enough points to simplify');
  }

  // Find the point with the maximum distance from the line between start/end.
  $dmax = 0;
  $index = 0;
  $end = count($points) - 1;
  $start_end_line = [$points[0], $points[$end]];
  for ($i = 1; $i < $end; $i++) {
    $dist = perpendicular_distance($points[$i], $start_end_line);
    if ($dist > $dmax) {
      $index = $i;
      $dmax = $dist;
    }
  }

  // If max distance is larger than epsilon, recursively simplify.
  if ($dmax > $epsilon) {
    $new_start = ramer_douglas_peucker(array_slice($points, 0, $index + 1), $epsilon);
    $new_end = ramer_douglas_peucker(array_slice($points, $index), $epsilon);
    array_pop($new_start);
    return array_merge($new_start, $new_end);
  }

  // Max distance is below epsilon, so return a line from with just the
  // start and end points.
  return [ $points[0], $points[$end]];
}

$polyline = [
  [0,0],
  [1,0.1],
  [2,-0.1],
  [3,5],
  [4,6],
  [5,7],
  [6,8.1],
  [7,9],
  [8,9],
  [9,9],
];

$result = ramer_douglas_peucker($polyline, 1.0);
print "Result:\n";
foreach ($result as $point) {
  print $point[0] . ',' . $point[1] . "\n";
}
