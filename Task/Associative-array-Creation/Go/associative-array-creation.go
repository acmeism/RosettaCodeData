// declare a nil map variable, for maps from string to int
var x map[string]int

// make an empty map
x = make(map[string]int)

// make an empty map with an initial capacity
x = make(map[string]int, 42)

// set a value
x["foo"] = 3

// getting values
y1 := x["bar"]     // zero value returned if no map entry exists for the key
y2, ok := x["bar"] // ok is a boolean, true if key exists in the map

// removing keys
delete(x, "foo")

// make a map with a literal
x = map[string]int{
	"foo": 2, "bar": 42, "baz": -1,
}
