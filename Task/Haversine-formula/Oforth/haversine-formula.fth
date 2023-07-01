import: math

: haversine(lat1, lon1, lat2, lon2)
| lat lon |

   lat2 lat1 - asRadian ->lat
   lon2 lon1 - asRadian ->lon

   lon 2 / sin sq lat1 asRadian cos * lat2 asRadian cos *
   lat 2 / sin sq + sqrt asin 2 * 6372.8 * ;

haversine(36.12, -86.67, 33.94, -118.40) println
