<?php
function hashJoin($table1, $index1, $table2, $index2) {
    // hash phase
    foreach ($table1 as $s)
        $h[$s[$index1]][] = $s;
    // join phase
    foreach ($table2 as $r)
    	foreach ($h[$r[$index2]] as $s)
	    $result[] = array($s, $r);
    return $result;
}

$table1 = array(array(27, "Jonah"),
           array(18, "Alan"),
           array(28, "Glory"),
           array(18, "Popeye"),
           array(28, "Alan"));
$table2 = array(array("Jonah", "Whales"),
           array("Jonah", "Spiders"),
           array("Alan", "Ghosts"),
           array("Alan", "Zombies"),
           array("Glory", "Buffy"),
           array("Bob", "foo"));

foreach (hashJoin($table1, 1, $table2, 0) as $row)
    print_r($row);
?>
