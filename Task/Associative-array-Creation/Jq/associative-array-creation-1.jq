# An empty object:
{}

# Its type:
{} | type
# "object"

# An object literal:
{"a": 97, "b" : 98}

# Programmatic object construction:
reduce ("a", "b", "c", "d") as $c ({}; . +  { ($c) : ($c|explode[.0])} )
# {"a":97,"c":99,"b":98,"d":100}

# Same as above:
reduce range (97;101) as $i ({}; . + { ([$i]|implode) : $i })

# Addition of a key/value pair by assignment:
{}["A"] = 65  # in this case, the object being added to is {}

# Alteration of the value of an existing key:
{"A": 65}["A"] = "AA"
