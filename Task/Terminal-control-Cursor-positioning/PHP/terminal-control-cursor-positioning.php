echo "\033[".$x.",".$y."H"; // Position line $y and column $x.
echo "\033[".$n."A"; // Up $n lines.
echo "\033[".$n."B"; // Down $n lines.
echo "\033[".$n."C"; // Forward $n columns.
echo "\033[".$n."D"; // Backward $n columns.
echo "\033[2J"; // Clear the screen, move to (0,0).
