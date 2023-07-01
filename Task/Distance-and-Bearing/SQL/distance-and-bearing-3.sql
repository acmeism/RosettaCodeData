Select
   Name "Name",
   Country "Country",
   ICAO "ICAO",
   ROUND(calculate_distance(51.514669, 2.198581, Latitude, Longitude, 'N'), 1) "Distance in NM",
   ROUND(calculate_bearing(51.514669, 2.198581, Latitude, Longitude), 0) "Bearing in °"
From
    airports
ORDER BY "Distance in NM"
LIMIT 20;
