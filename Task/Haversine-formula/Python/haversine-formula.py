>>> import math
>>> def haversine(lat1, lon1, lat2, lon2):
  R = 6372.8
  # In kilometers
  dLat = math.radians(lat2 - lat1)
  dLon = math.radians(lon2 - lon1)
  lat1 = math.radians(lat1)
  lat2 = math.radians(lat2)

  a = math.sin(dLat / 2) * math.sin(dLat / 2) + math.sin(dLon / 2) * math.sin(dLon / 2) * math.cos(lat1) * math.cos(lat2)
  c = 2 * math.asin(math.sqrt(a))
  return R * c

>>> haversine(36.12, -86.67, 33.94, -118.40)
2887.2599506071106
>>>
