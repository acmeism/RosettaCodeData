<?php
echo "<h1>" . "Choose: ROCK - PAPER - SCISSORS" . "</h1>";
echo "<h2>";
echo "";

$player = strtoupper( $_GET["moves"] );
$wins = [
    'ROCK' => 'SCISSORS',
    'PAPER' => 'ROCK',
    'SCISSORS' => 'PAPER'
  ];
$a_i = array_rand($wins);
echo "<br>";
echo "Player chooses " . "<i style=\"color:blue\">" . $player . "</i>";
echo "<br>";
echo "<br>" . "A.I chooses " . "<i style=\"color:red\">"  . $a_i . "</i>";

$results = "";
if ($player == $a_i){
$results = "Draw";
} else if($wins[$a_i] == $player ){
  $results = "A.I wins";
} else {
  $results = "Player wins";
}

echo "<br>" . $results;
?>
