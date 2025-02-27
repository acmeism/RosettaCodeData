const
  r = 6372.8;

function haversine(lat1, lon1, lat2, lon2: real): real;
begin
  var  dLat := degToRad(lat2 - lat1);
  var  dLon := degToRad(lon2 - lon1);
  lat1 := degToRad(lat1);
  lat2 := degToRad(lat2);

  var a := sin(dLat / 2) * sin(dLat / 2) + cos(lat1) * cos(lat2) * sin(dLon / 2) * sin(dLon / 2);
  var c := 2 * arcsin(sqrt(a));

  result := r * c;
end;

begin
  haversine(36.12, -86.67, 33.94, -118.40).Println;
end.
