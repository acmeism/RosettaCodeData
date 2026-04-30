# Monty Hall Problem
$script:NGames = 10000

function Is-Game-Won($Sw) {
  # Play one game.
  # Switching if and only if $Sw -ne 0.
  $car = Get-Random -maximum 3 # Randomly place car behind a door.
  $player0 = Get-Random -maximum 3 # Player randomly chooses a door.
  do {
    $monty = Get-Random -maximum 3 # Monty opens door revealing a goat.
  } while (($monty -eq $car) -or ($monty -eq $player0))
  if ($Sw -ne 0) { # Player switches to remaining door.
    do {
      $player = Get-Random -maximum 3
    } while (($player -eq $player0) -or ($player -eq $monty))
  } else {
    $player = $player0 # Player sticks with original door.
  }
  return [bool]($player -eq $car)
}

$nWins = 0
foreach ($game in 1..$script:NGames) {
  if (Is-Game-Won(0)) {
    $nWins++
  }
}
$row = "NOT switching doors wins car in "
$row += "$(($nWins / $script:NGames * 100).ToString('##.#'))% of games."
Write-Output $row
$nWins = 0
foreach ($game in 1..$script:NGames) {
  if (Is-Game-Won(1) -ne 0) {
    $nWins++
  }
}
$row = "But switching doors wins car in "
$row += "$(($nWins / $script:NGames * 100).ToString('##.#'))% of games."
Write-Output $row
