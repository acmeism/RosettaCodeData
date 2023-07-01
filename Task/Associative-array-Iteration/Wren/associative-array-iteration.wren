// create a new map with four entries
var capitals = {
    "France": "Paris",
    "Germany": "Berlin",
    "Russia": "Moscow",
    "Spain": "Madrid"
}

// iterate through the map and print out the key/value pairs
for (c in capitals) System.print([c.key, c.value])
System.print()

// iterate though the map and print out just the keys
for (k in capitals.keys) System.print(k)
System.print()

// iterate though the map and print out just the values
for (v in capitals.values) System.print(v)
