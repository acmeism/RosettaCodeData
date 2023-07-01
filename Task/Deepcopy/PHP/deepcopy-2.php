<?php

// stdClass is a default PHP object
$object = new stdClass;
$object->some_value = 1;
$object->child = new stdClass;
$object->child->some_value = 1;

$deepcopy = unserialize(serialize($object));
$deepcopy->some_value++;
$deepcopy->child->some_value++;

echo "Object contains {$object->some_value}, child contains {$object->child->some_value}\n",
     "Clone of object contains {$deepcopy->some_value}, child contains {$deepcopy->child->some_value}\n";
