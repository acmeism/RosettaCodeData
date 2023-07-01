let myMap = [
	   "hello": 13,
	   "world": 31,
	   "!"    : 71 ]

// iterating over key-value pairs:
for (key, value) in myMap {
	print("key = \(key), value = \(value)")
}
// Just the keys
for key in myMap.keys
{
	print("key = \(key)")
}
// Just the values
for value in myMap.values
{
	print("value = \(value)")
}
