function rad = radians(degree)
% degrees to radians
    rad = degree * pi / 180;
end;

function [a,c,dlat,dlon]=haversine(lat1,lon1,lat2,lon2)
% HAVERSINE_FORMULA.AWK - converted from AWK
    dlat = radians(lat2-lat1);
    dlon = radians(lon2-lon1);
    lat1 = radians(lat1);
    lat2 = radians(lat2);
    a = (sin(dlat/2))^2 + cos(lat1) * cos(lat2) * (sin(dlon/2))^2;
    c = 2 * atan2(sqrt(a),sqrt(1-a));
    printf("distance: %.4f km\n",6372.8 * c);
end

[a,c,dlat,dlon] = haversine(36.12,-86.67,33.94,-118.40); % BNA to LAX
