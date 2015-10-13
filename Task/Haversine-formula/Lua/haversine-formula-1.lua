local function haversine(x1, y1, x2, y2)
r=0.017453292519943295769236907684886127;
x1= x1*r; x2= x2*r; y1= y1*r; y2= y2*r; dy = y2-y1; dx = x2-x1;
a = math.pow(math.sin(dx/2),2) + math.cos(x1) * math.cos(x2) * math.pow(math.sin(dy/2),2); c = 2 * math.asin(math.sqrt(a)); d = 6372.8 * c;
return d;
end
