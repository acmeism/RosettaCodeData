$doors = @(0..99)
for($i=0; $i -lt 100; $i++) {
  $doors[$i] = 0  # start with all doors closed
}
for($i=0; $i -lt 100; $i++) {
  $step = $i + 1
  for($j=$i; $j -lt 100; $j = $j + $step) {
    $doors[$j] = $doors[$j] -bxor 1
  }
}
foreach($doornum in 1..100) {
  if($doors[($doornum-1)] -eq $true) {"$doornum open"}
  else {"$doornum closed"}
}
