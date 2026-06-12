import "./fmt" for Fmt
import "./big" for BigInt

// functions to convert to and from the word format 'W00000'
var toWord   = Fn.new { |w| Fmt.swrite("W$05d", w) }
var fromWord = Fn.new { |w| Num.fromString(w[1..-1]) }

// set latitude and longitude and print them
System.print("Starting figures:")
var lat = 28.3852
var lon = -81.5638
Fmt.print("  latitude = $0.4f, longitude = $0.4f", lat, lon)

// convert lat and lon to positive BigInts
var ilat = BigInt.new(lat * 10000 + 900000)
var ilon = BigInt.new(lon * 10000 + 1800000)

// build 43 bit BigInt comprising 21 bits (lat) and 22 bits (lon)
var latlon = (ilat << 22) + ilon

// isolate relevant bits and convert back to 'normal' ints
var w1 = ((latlon >> 28) & 0x7fff).toSmall
var w2 = ((latlon >> 14) & 0x3fff).toSmall
var w3 = (latlon & 0x3fff).toSmall

// convert to word format
w1 = toWord.call(w1)
w2 = toWord.call(w2)
w3 = toWord.call(w3)

// and print the results
System.print("\nThree word location is:")
Fmt.print("  $s $s $s", w1, w2, w3)

/* now reverse the procedure */
w1 = BigInt.new(fromWord.call(w1))
w2 = BigInt.new(fromWord.call(w2))
w3 = BigInt.new(fromWord.call(w3))
latlon = (w1 << 28) | (w2 << 14) | w3
ilat = (latlon >> 22).toSmall
ilon = (latlon & 0x3fffff).toSmall
lat = (ilat - 900000) / 10000
lon = (ilon - 1800000) / 10000

// and print the results
System.print("\nAfter reversing the procedure:")
Fmt.print("  latitude = $0.4f, longitude = $0.4f", lat, lon)
