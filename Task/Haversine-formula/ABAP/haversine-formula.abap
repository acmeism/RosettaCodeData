DATA : lat1 TYPE char20 VALUE '36.12' ,
       lon1 TYPE char20 VALUE '-86.67' ,
       lat2 TYPE char20 VALUE '33.94' ,
       lon2 TYPE char20 VALUE '-118.4' ,
       distance TYPE p DECIMALS 1 .
CONSTANTS : pi TYPE char20 VALUE '3.141592654',
            earth_radius TYPE char20 VALUE '6372.8' ."in km
distance = earth_radius * acos( cos( ( 90 - lat1 ) * ( pi / 180 ) ) * cos( ( 90 - lat2 ) * ( pi / 180 ) ) +  sin( ( 90 - lat1 ) * ( pi / 180 ) ) * sin( ( 90 - lat2 ) * ( pi / 180 ) ) * cos( ( lon1 - lon2 ) * ( pi / 180 ) ) ) .
WRITE : 'Distance between given points = ' , distance , 'km .' .
