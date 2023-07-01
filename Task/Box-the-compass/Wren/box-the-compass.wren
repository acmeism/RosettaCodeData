import "/fmt" for Fmt

// 'cpx' returns integer index from 0 to 31 corresponding to compass point.
// Input heading h is in degrees.  Note this index is a zero-based index
// suitable for indexing into the table of printable compass points,
// and is not the same as the index specified to be printed in the output.
var cpx = Fn.new { |h|
    var x = (h/11.25+0.5).floor % 32
    if (x < 0) x = x + 32
    return x
}

// printable compass points
var compassPoint = [
    "North",
    "North by east",
    "North-northeast",
    "Northeast by north",
    "Northeast",
    "Northeast by east",
    "East-northeast",
    "East by north",
    "East",
    "East by south",
    "East-southeast",
    "Southeast by east",
    "Southeast",
    "Southeast by south",
    "South-southeast",
    "South by east",
    "South",
    "South by west",
    "South-southwest",
    "Southwest by south",
    "Southwest",
    "Southwest by west",
    "West-southwest",
    "West by south",
    "West",
    "West by north",
    "West-northwest",
    "Northwest by west",
    "Northwest",
    "Northwest by north",
    "North-northwest",
    "North by west"
]

// function required by task
var degreesToCompassPoint = Fn.new { |h| compassPoint[cpx.call(h)] }

var r = [
    0.0, 16.87, 16.88, 33.75, 50.62, 50.63, 67.5,
    84.37, 84.38, 101.25, 118.12, 118.13, 135.0, 151.87, 151.88, 168.75,
    185.62, 185.63, 202.5, 219.37, 219.38, 236.25, 253.12, 253.13, 270.0,
    286.87, 286.88, 303.75, 320.62, 320.63, 337.5, 354.37, 354.38
]

System.print("Index  Compass point         Degree")
var i = 0
for (h in r) {
    var index = i%32 + 1  // printable index computed per pseudocode
    var d = degreesToCompassPoint.call(h)
    System.print("%(Fmt.d(4, index))   %(Fmt.s(-19, d)) %(Fmt.f(7, h, 2))°")
    i = i + 1
}
