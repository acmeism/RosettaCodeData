<?php
function printAll(...$things) {
  foreach ($things as $x)
    echo "$x\n";
}
printAll(4, 3, 5, 6, 4, 3);
printAll(4, 3, 5);
printAll("Rosetta", "Code", "Is", "Awesome!");
?>
