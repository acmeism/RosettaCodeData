import "io" for File
import "./dynamic" for Tuple
import "./str" for Str
import "./fmt" for Fmt

var airportFields = [
    "airportID",
    "name",
    "city",
    "country",
    "iata",
    "icao",
    "latitude",
    "longitude",
    "altitude",
    "timezone",
    "dst",
    "tzOlson",
    "type",
    "source"
]
var Airport = Tuple.create("Airport", airportFields)

var fileName = "airports.dat" // local copy
var lines = File.read(fileName).trimEnd().split("\n")
var lc = lines.count
var airports = List.filled(lc, null)
for (i in 0...lc) {
    var fields    = lines[i].split(",").map { |f| f.replace("\"", "") }.toList
    if (fields.count > 14) {  // there are field(s) with embedded comma(s)
        fields    = Str.splitCsv(lines[i])
    }
    var airportID = Num.fromString(fields[0])
    var name      = fields[1]
    var city      = fields[2]
    var country   = fields[3]
    var iata      = fields[4]
    var icao      = fields[5]
    var latitude  = Num.fromString(fields[6])
    var longitude = Num.fromString(fields[7])
    var altitude  = Num.fromString(fields[8])
    var timezone  = fields[9]
    var dst       = fields[10]
    var tzOlson   = fields[11]
    var type      = fields[12]
    var source    = fields[13]
    airports[i]   = Airport.new(airportID, name, city, country, iata, icao, latitude, longitude,
                                altitude, timezone, dst, tzOlson, type, source)
}

var calculateDistance = Fn.new { |lat1, lon1, lat2, lon2, units|
    if (lat1 == lat2 && lon1 == lon2) return 0
    var radlat1 = Num.pi * lat1 / 180
    var radlat2 = Num.pi * lat2 / 180
    var theta = lon1 - lon2
    var radtheta = Num.pi * theta / 180
    var dist = radlat1.sin * radlat2.sin + radlat1.cos * radlat2.cos * radtheta.cos
    if (dist > 1) dist = 1
    dist = dist.acos * 180 / Num.pi * 60 * 1.1515576  // distance in statute miles
    if (units == "K") dist = dist * 1.609344          // distance in kilometers
    if (units == "N") dist = dist * 0.868976          // distance in nautical miles
    return dist
}

var calculateBearing = Fn.new { |lat1, lon1, lat2, lon2|
    if (lat1 == lat2 && lon1 == lon2) return 0
    var radlat1 = Num.pi * lat1 / 180
    var radlat2 = Num.pi * lat2 / 180
    var raddlon = Num.pi * (lon2 - lon1) / 180
    var y = raddlon.sin * radlat2.cos
    var x = radlat1.cos * radlat2.sin - radlat1.sin * radlat2.cos * raddlon.cos
    var bear = y.atan(x) * 180 / Num.pi
    return (bear + 360) % 360
}

// request from airplane at position (51.514669, 2.198581)
var query = List.filled(airports.count, null)
for (i in 0...airports.count) {
    var a = airports[i]
    var dist = calculateDistance.call(51.514669, 2.198581, a.latitude, a.longitude, "N")
    dist = (dist * 10).round / 10
    var bear = calculateBearing.call(51.514669, 2.198581, a.latitude, a.longitude).round
    query[i] = [a.name, a.country, a.icao, dist, bear]
}
query.sort { |q1, q2| q1[3] < q2[3] }
System.print("                Name                 |    Country     | ICAO | Distance in NM | Bearing in ° ")
System.print("-------------------------------------+----------------+------+----------------+--------------")
var fmt = " $-36s| $-15s| $4s |           $4.1f |          $3d"
for (i in 0..19) Fmt.lprint(fmt, query[i])
System.print("(20 rows)")
