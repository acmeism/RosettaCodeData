include Math

def haversine(lat1, lon1, lat2, lon2)
    r = 6372.8        # Earth radius in kilometers
    deg2rad = PI/180  # convert degress to radians

    dLat = (lat2 - lat1) * deg2rad
    dLon = (lon2 - lon1) * deg2rad
    lat1 = lat1 * deg2rad
    lat2 = lat2 * deg2rad

    a = sin(dLat / 2)**2 + cos(lat1) * cos(lat2) * sin(dLon / 2)**2
    c = 2 * asin(sqrt(a))
    r * c
end

puts "distance is #{haversine(36.12, -86.67, 33.94, -118.40)} km "
