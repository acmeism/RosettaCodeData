<?
class Foo {
    function bar(int $x) {
    }
}

$method_names = get_class_methods('Foo');
foreach ($method_names as $name) {
    echo "$name\n";
    $method_info = new ReflectionMethod('Foo', $name);
    echo $method_info;
}
?>
