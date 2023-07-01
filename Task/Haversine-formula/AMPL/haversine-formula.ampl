set location;
set geo;

param coord{i in location, j in geo};
param dist{i in location, j in location};

data;

set location := BNA LAX;
set geo := LAT LON;

param coord:
               LAT      LON :=
      BNA    36.12   -86.67
      LAX    33.94   -118.4
;

let dist['BNA','LAX'] := 2 * 6372.8 * asin (sqrt(sin(atan(1)/45*(coord['LAX','LAT']-coord['BNA','LAT'])/2)^2 + cos(atan(1)/45*coord['BNA','LAT']) * cos(atan(1)/45*coord['LAX','LAT']) * sin(atan(1)/45*(coord['LAX','LON'] - coord
['BNA','LON'])/2)^2));

printf "The distance between the two points is approximately %f km.\n", dist['BNA','LAX'];
