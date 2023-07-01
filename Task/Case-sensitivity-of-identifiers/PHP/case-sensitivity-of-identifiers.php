<?php

// In true PHP style, this example is inconsistent.
// Variable identifiers are case sensitive

$dog = 'Benjamin';
$Dog = 'Samba';
$DOG = 'Bernie';

echo "There are 3 dogs named {$dog}, {$Dog} and {$DOG}\n";

// Whereas function identifiers are case insensitive

function DOG() { return 'Bernie'; }

echo 'There is only 1 dog named ' . dog() . "\n";
