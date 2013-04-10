// items in map where the key is greater than 3
map.filter {k => k._1 > 3} //  Map(5 -> 6, 44 -> 99)
// same with for syntax
for((k, v) <- map; if k > 3) yield (k,v)
