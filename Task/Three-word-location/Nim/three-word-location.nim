import strformat, strutils

func toWord(w: int64): string = &"W{w:05}"

func fromWord(ws: string): int64 = ws[1..5].parseInt()

echo "Starting figures:"
var
  lat = 28.3852
  long = -81.5638
echo &"  latitude = {lat:0.4f}, longitude = {long:0.4f}"

# Convert "lat" and "long" to positive integers.
var
  ilat = int64(lat * 10_000 + 900_000)
  ilong = int64(long * 10_000 + 1_800_000)

# Build 43 bit int comprising 21 bits (lat) and 22 bits (lon).
var latlong = ilat shl 22 + ilong

# Isolate relevant bits.
var
  w1 = latlong shr 28 and 0x7fff
  w2 = latlong shr 14 and 0x3fff
  w3 = latlong and 0x3fff

# Convert to word format.
let
  w1s = w1.toWord
  w2s = w2.toWord
  w3s = w3.toWord

# Print the results.
echo "\nThree word location is:"
echo &"  {w1s} {w2s} {w3s}"

# Reverse the procedure.
w1 = w1s.fromWord
w2 = w2s.fromWord
w3 = w3s.fromWord

latlong = w1 shl 28 or w2 shl 14 or w3
ilat = latlong shr 22
ilong = latlong and 0x3fffff
lat = float(ilat - 900_000) / 10_000
long = float(ilong - 1_800_000) / 10_000

# Print the results.
echo "\nAfter reversing the procedure:"
echo &"  latitude = {lat:0.4f}, longitude = {long:0.4f}"
