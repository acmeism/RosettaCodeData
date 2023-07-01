var mergeMaps = Fn.new { |m1, m2|
    var m3 = {}
    for (key in m1.keys) m3[key] = m1[key]
    for (key in m2.keys) m3[key] = m2[key]
    return m3
}

var base = { "name": "Rocket Skates" , "price": 12.75, "color": "yellow" }
var update = { "price": 15.25, "color": "red", "year": 1974 }
var merged = mergeMaps.call(base, update)
System.print(merged)
