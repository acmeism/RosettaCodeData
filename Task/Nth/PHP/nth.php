function nth($num) {
  $os = "th";
  if ($num % 100 <= 10 or $num % 100 > 20) {
    switch ($num % 10) {
      case 1:
        $os = "st";
        break;
      case 2:
        $os = "nd";
        break;
      case 3:
        $os = "rd";
        break;
    }
  }
  return $num . $os;
}

foreach ([[0,25], [250,265], [1000,1025]] as $i) {
  while ($i[0] <= $i[1]) {
    echo nth($i[0]) . " ";
    $i[0]++;
  }
  echo "\n";
}
