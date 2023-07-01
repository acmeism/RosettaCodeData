<?php
class SimpleClass {
    private $answer = 42;
}

$class = new SimpleClass;
$classvars = (array)$class;
echo $classvars["\0SimpleClass\0answer"];
