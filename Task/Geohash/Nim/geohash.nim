import math, strformat, strutils, sugar, tables

const
  Ch32 = "0123456789bcdefghjkmnpqrstuvwxyz"
  Bool2Ch = collect(initTable, for i, ch in Ch32: {i.toBin(5): ch})
  Ch2Bool = collect(initTable, for k, v in Bool2Ch: {v: k})


func bisect(val, mn, mx: float; bits: int64): (float, float, int64) =
  var
    bits = bits
    mn = mn
    mx = mx
  let mid = (mn + mx) * 0.5
  if val < mid:
    bits = bits shl 1       # push 0.
    mx = mid                # range lower half.
  else:
    bits = bits shl 1 or 1  # push 1.
    mn = mid                # range upper half.
  result = (mn, mx, bits)


func encode(lat, long: float; pre: int64): string =
  var
    (latmin, latmax) = (-90.0, 90.0)
    (longmin, longmax) = (-180.0, 180.0)
    bits = 0i64

  for i in 0..<(5 * pre):
    if (i and 1) != 0:
      # Odd bit: bisect latitude.
      (latmin, latmax, bits) = bisect(lat, latmin, latmax, bits)
    else:
      # Even bit: bisect longitude.
      (longmin, longmax, bits) = bisect(long, longmin, longmax, bits)
    # Bits to characters.
    let b = bits.toBin(pre * 5)
    let geo = collect(newSeq, for i in 0..<pre: Bool2Ch[b[i*5..i*5+4]])
    result = geo.join()


func decode(geo: string): array[2, array[2, float]] =
  var latlong = 1
  result = [[-90.0, 90.0], [-180.0, 180.0]]
  for c in geo:
    for bit in Ch2Bool[c]:
      result[latlong][ord(bit != '1')] = sum(result[latlong]) * 0.5
      latlong = 1 - latlong


when isMainModule:
  for (lat, long, pre) in [(51.433718, -0.214126,  2),
                           (51.433718, -0.214126,  9),
                           (57.64911,  10.40744 , 11)]:
    let encoded = encode(lat, long, pre)
    echo &"encoder(lat = {lat}, long = {long}, pre = {pre}) = {encoded}"
    echo &"decoded = {decode(encoded)}
