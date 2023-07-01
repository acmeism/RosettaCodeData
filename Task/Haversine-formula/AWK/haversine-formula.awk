# syntax: GAWK -f HAVERSINE_FORMULA.AWK
# converted from Python
BEGIN {
    distance(36.12,-86.67,33.94,-118.40) # BNA to LAX
    exit(0)
}
function distance(lat1,lon1,lat2,lon2,  a,c,dlat,dlon) {
    dlat = radians(lat2-lat1)
    dlon = radians(lon2-lon1)
    lat1 = radians(lat1)
    lat2 = radians(lat2)
    a = (sin(dlat/2))^2 + cos(lat1) * cos(lat2) * (sin(dlon/2))^2
    c = 2 * atan2(sqrt(a),sqrt(1-a))
    printf("distance: %.4f km\n",6372.8 * c)
}
function radians(degree) { # degrees to radians
    return degree * (3.1415926 / 180.)
}
