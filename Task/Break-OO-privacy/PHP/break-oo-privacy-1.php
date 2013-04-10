<?php
class SimpleClass {
    private $answer = "hello\"world\nforever :)";
}

$class = new SimpleClass;
ob_start();

// var_export() expects class to contain __set_state() method which would import
// data from array. But let's ignore this and remove from result the method which
// sets state and just leave data which can be used everywhere...
var_export($class);
$class_content = ob_get_clean();

$class_content = preg_replace('"^SimpleClass::__set_state\("', 'return ', $class_content);
$class_content = preg_replace('"\)$"', ';', $class_content);

$new_class = eval($class_content);
echo $new_class['answer'];
