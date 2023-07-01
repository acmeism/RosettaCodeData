var a = [1,2,3,4,5,6,7,8,9]
var b: array[128, int]
b[9] = 10
b[0..8] = a
var c: array['a'..'d', float] = [1.0, 1.1, 1.2, 1.3]
c['b'] = 10000
