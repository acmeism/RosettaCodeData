require 'open-uri'
require 'csv'
include Math

RADIUS = 6372.8  # rough radius of the Earth, in kilometers

def spherical_distance(start_coords, end_coords)
  lat1, long1 = deg2rad(*start_coords)
  lat2, long2 = deg2rad(*end_coords)
  2 * RADIUS * asin(sqrt(sin((lat2-lat1)/2)**2 + cos(lat1) * cos(lat2) * sin((long2 - long1)/2)**2))
end

def bearing(start_coords, end_coords)
  lat1, long1 = deg2rad(*start_coords)
  lat2, long2 = deg2rad(*end_coords)
  dlon = long2 - long1
  atan2(sin(dlon) * cos(lat2), cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dlon))
end

def deg2rad(lat, long)
  [lat * PI / 180, long * PI / 180]
end

uri = "https://raw.githubusercontent.com/jpatokal/openflights/master/data/airports.dat"
headers = %i(airportID
    name
    city
    country
    iata
    icao
    latitude
    longitude
    altitude
    timezone
    dst
    tzOlson
    type
    source)
data = CSV.parse(URI.open(uri), headers: headers, converters: :numeric)

position = [51.514669, 2.198581]

data.each{|r| r[:dist] = (spherical_distance(position, [r[:latitude], r[:longitude]])/1.852).round(1)}
closest =  data.min_by(20){|row| row[:dist] }
closest.each do |r|
  bearing = (bearing(position,[r[:latitude], r[:longitude]])*180/PI).round % 360
  puts "%-40s %-25s %-6s %12.1f %15.0f" % (r.values_at(:name, :country, :ICAO, :dist) << bearing)
end
