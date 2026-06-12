object Base32 {
  val base32 = "0123456789bcdefghjkmnpqrstuvwxyz" // no "a", "i", "l", or "o"
}

case class Coordinate(latitude: Double, longitude: Double) {
  override def toString: String = {
    val latitudeHemisphere = if (latitude < 0) " S" else " N"
    val longitudeHemisphere = if (longitude < 0) " W" else " E"
    s"${math.abs(latitude)}$latitudeHemisphere, ${math.abs(longitude)}$longitudeHemisphere"
  }
}

object GeoHashEncoder {
  def encodeGeohash(coordinate: Coordinate, precision: Int = 9): String = {
    var latitudeRange: (Double, Double) = (-90.0, 90.0)
    var longitudeRange: (Double, Double) = (-180.0, 180.0)

    var hash = ""
    var hashVal = 0
    var bits = 0
    var even = true

    while (hash.length < precision) {
      val valCoord = if (even) coordinate.longitude else coordinate.latitude
      val (rangeStart, rangeEnd) = if (even) longitudeRange else latitudeRange
      val mid = (rangeStart + rangeEnd) / 2

      if (valCoord > mid) {
        hashVal = (hashVal << 1) + 1
        if (even) longitudeRange = (mid, rangeEnd) else latitudeRange = (mid, rangeEnd)
      } else {
        hashVal = (hashVal << 1)
        if (even) longitudeRange = (rangeStart, mid) else latitudeRange = (rangeStart, mid)
      }

      even = !even

      if (bits < 4) {
        bits += 1
      } else {
        bits = 0
        hash += Base32.base32.charAt(hashVal)
        hashVal = 0
      }
    }
    hash
  }
}

object Main extends App {
  val coordinate1 = Coordinate(51.433718, -0.214126)
  val coordinate2 = Coordinate(57.649110, 10.407440)

  println(s"Geohash for: ${coordinate1.toString}, precision = 5 : ${GeoHashEncoder.encodeGeohash(coordinate1, 5)}")
  println(s"Geohash for: ${coordinate1.toString}, precision = 9 : ${GeoHashEncoder.encodeGeohash(coordinate1)}")
  println(s"Geohash for: ${coordinate2.toString}, precision = 11 : ${GeoHashEncoder.encodeGeohash(coordinate2, 11)}")
}
