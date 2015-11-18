$ages = array();
for($i=0; $i < 100; $i++) {
  array_push($ages, rand(0, 140));
}
counting_sort($ages, 0, 140);

for($i=0; $i < 100; $i++) {
  echo $ages[$i] . "\n";
}
?>
