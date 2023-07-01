fn main() {
    // make empty map
    mut my_map := map[string]int{}

    //s et value
    my_map['foo'] = 3

    // getting values
    y1 := my_map['foo']

    // remove keys
    my_map.delete('foo')

    // make map with values
    my_map = {
        'foo': 2
        'bar': 42
        'baz': -1
    }
}
