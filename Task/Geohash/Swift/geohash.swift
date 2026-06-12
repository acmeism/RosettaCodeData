let base32 = "0123456789bcdefghjkmnpqrstuvwxyz" // no "a", "i", "l", or "o"

extension String {
  subscript(i: Int) -> String {
    String(self[index(startIndex, offsetBy: i)])
  }
}

struct Coordinate {
  var latitude: Double
  var longitude: Double

  func toString() -> String {
    var latitudeHemisphere = ""
    var longitudeHemisphere = ""

    latitudeHemisphere = latitude < 0 ? " S" : " N"
    longitudeHemisphere = longitude < 0 ? " W" : " E"

    return "\(abs(latitude))\(latitudeHemisphere), \(abs(longitude))\(longitudeHemisphere)"
  }
}

func encodeGeohash (for coordinate: Coordinate, withPrecision precision: Int = 9) -> String {
  var latitudeRange = -90.0...90.0
  var longitudeRange = -180...180.0

  var hash = ""
  var hashVal = 0
  var bits = 0
  var even = true

  while (hash.count < precision) {
    let val     = even ? coordinate.longitude: coordinate.latitude
    var range   = even ? longitudeRange : latitudeRange
    let mid     = (range.lowerBound + range.upperBound) / 2

    if (val > mid) {
      hashVal = (hashVal << 1) + 1
      range = mid...range.upperBound

      if even { longitudeRange = mid...longitudeRange.upperBound }
      else    {  latitudeRange = mid...latitudeRange.upperBound }
    } else {
      hashVal = (hashVal << 1) + 0
      range   = range.lowerBound...mid

      if even { longitudeRange = longitudeRange.lowerBound...mid }
      else    {  latitudeRange =  latitudeRange.lowerBound...mid }
    }

    even = !even

    if (bits < 4) {
      bits += 1
    } else {
      bits = 0
      hash += base32[hashVal]
      hashVal = 0
    }
  }
  return hash
}

let coordinate1 = Coordinate(latitude: 51.433718, longitude: -0.214126)
let coordinate2 = Coordinate(latitude: 57.649110, longitude: 10.407440)

print ("Geohash for: \(coordinate1.toString()), precision = 5 : \(encodeGeohash(for: coordinate, withPrecision: 5))")
print ("Geohash for: \(coordinate1.toString()), precision = 9 : \(encodeGeohash(for: coordinate))")
print ("Geohash for: \(coordinate2.toString()), precision = 11 : \(encodeGeohash(for: coordinate, withPrecision: 11))")

