using DataFrames
using CSV

const EARTH_RADIUS_KM = 6372.8
const TASK_CONVERT_NM = 0.0094174
const AIRPORT_DATA_FILE = "airports.dat.txt"

const QUERY = (latitude =  51.514669, longitude = 2.198581)

"""
Given two latitude, longitude pairs in degrees for two points on the Earth,
get distance (nautical miles) and initial direction of travel (degrees)
for travel from lat1, lon1 to lat2, lon2
"""
function haversine(lat1, lon1, lat2, lon2)
    dlat = lat2 - lat1
    dlon = lon2 - lon1
    a = sind(dlat / 2)^2 + cosd(lat1) * cosd(lat2) * sind(dlon / 2)^2
    c = 2.0 * asind(sqrt(a))
    theta = atand(sind(dlon) * cosd(lat2),
        cosd(lat1) * sind(lat2) - sind(lat1) * cosd(lat2) * cosd(dlon))
    theta = (theta + 360) % 360
    return EARTH_RADIUS_KM * c * TASK_CONVERT_NM, theta
end

""" Given latitude and longitude, find `wanted` closest airports in database file csv. """
function find_nearest_airports(latitude, longitude, wanted = 20, csv = AIRPORT_DATA_FILE)
    airports = DataFrame(CSV.File(csv))[:, [2, 4, 6, 7, 8]]
    airports[!, "d"] .= 0.0
    airports[!, "b"] .= 0
    rename!(airports, [:Name, :Country, :ICAO, :Latitude_deg, :Longitude_deg, :Distance, :Bearing])
    for r in eachrow(airports)
        distance, bearing = haversine(latitude, longitude, r.Latitude_deg, r.Longitude_deg)
        r.Distance, r.Bearing = round(distance, digits = 1), Int(round(bearing))
    end
    sort!(airports, :Distance)
    return airports[1:wanted, [:Name, :Country, :ICAO, :Distance, :Bearing]]
end

println(find_nearest_airports(QUERY.latitude, QUERY.longitude))
