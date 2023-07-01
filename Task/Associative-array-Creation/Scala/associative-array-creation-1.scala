// immutable maps
var map = Map(1 -> 2, 3 -> 4, 5 -> 6)
map(3) // 4
map = map + (44 -> 99) // maps are immutable, so we have to assign the result of adding elements
map.isDefinedAt(33) // false
map.isDefinedAt(44) // true
