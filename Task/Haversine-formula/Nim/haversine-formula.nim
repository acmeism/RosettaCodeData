import math

proc radians(x): float = x * Pi / 180

proc haversine(lat1, lon1, lat2, lon2): float =
  const r = 6372.8 # Earth radius in kilometers
  let
    dLat = radians(lat2 - lat1)
    dLon = radians(lon2 - lon1)
    lat1 = radians(lat1)
    lat2 = radians(lat2)

    a = sin(dLat/2)*sin(dLat/2) + cos(lat1)*cos(lat2)*sin(dLon/2)*sin(dLon/2)
    c = 2*arcsin(sqrt(a))

  result = r * c

echo haversine(36.12, -86.67, 33.94, -118.40)
