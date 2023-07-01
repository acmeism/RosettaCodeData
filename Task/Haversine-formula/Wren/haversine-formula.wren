var R = 6372.8  // Earth's approximate radius in kilometers.

/*  Class containing trig methods which work with degrees rather than radians. */
class D {
    static deg2Rad(deg) { (deg*Num.pi/180 + 2*Num.pi) % (2*Num.pi) }
    static sin(d) { deg2Rad(d).sin }
    static cos(d) { deg2Rad(d).cos }
}

var haversine = Fn.new { |lat1, lon1, lat2, lon2|
    var dlat = lat2 - lat1
    var dlon = lon2 - lon1
    return 2 * R * (D.sin(dlat/2).pow(2) + D.cos(lat1) * D.cos(lat2) * D.sin(dlon/2).pow(2)).sqrt.asin
}

System.print(haversine.call(36.12, -86.67, 33.94, -118.4))
