var subtract = Fn.new { |b1, b2|
    var d = (b2 - b1) % 360
    if (d < -180)  d = d + 360
    if (d >= 180)  d = d - 360
    return (d * 10000).round / 10000 // to 4dp
}

var pairs = [
    [ 20,  45],
    [-45,  45],
    [-85,  90],
    [-95,  90],
    [-45, 125],
    [-45, 145],
    [ 29.4803, -88.6381],
    [-78.3251, -159.036],
    [-70099.74233810938, 29840.67437876723],
    [-165313.6666297357, 33693.9894517456],
    [1174.8380510598456, -154146.66490124757],
    [60175.77306795546, 42213.07192354373]
]

System.print("Differences (to 4dp) between these bearings:")
for (pair in pairs) {
    var p0 = pair[0]
    var p1 = pair[1]
    var diff = subtract.call(p0, p1)
    var offset = (p0 < 0) ? " " : "  "
    System.print("%(offset)%(p0) and %(p1) -> %(diff)")
}
