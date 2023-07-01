<?
class Foo {
}
$obj = new Foo();
$obj->bar = 42;
$obj->baz = true;

var_dump(get_object_vars($obj));
?>
