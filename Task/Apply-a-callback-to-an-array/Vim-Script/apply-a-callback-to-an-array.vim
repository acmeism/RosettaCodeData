echo map([10, 20, 30], 'v:val * v:val')
echo map([10, 20, 30], '"Element " . v:key . " = " . v:val')
echo map({"a": "foo", "b": "Bar", "c": "BaZ"}, 'toupper(v:val)')
echo map({"a": "foo", "b": "Bar", "c": "BaZ"}, 'toupper(v:key)')
