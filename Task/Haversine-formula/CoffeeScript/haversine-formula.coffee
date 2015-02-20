haversine = (args...) ->
  R = 6372.8; # km
  radians = args.map (deg) -> deg/180.0 * Math.PI
  lat1 = radians[0]; lon1 = radians[1]; lat2 = radians[2]; lon2 = radians[3]
  dLat = lat2 - lat1
  dLon = lon2 - lon1
  a = Math.sin(dLat / 2) * Math.sin(dLat / 2) + Math.sin(dLon / 2) * Math.sin(dLon / 2) * Math.cos(lat1) * Math.cos(lat2)
  R * 2 * Math.asin(Math.sqrt(a))

console.log haversine(36.12, -86.67, 33.94, -118.40)
