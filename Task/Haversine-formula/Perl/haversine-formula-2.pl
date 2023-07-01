use Math::Trig qw(great_circle_distance deg2rad);

# Notice the 90 - latitude: phi zero is at the North Pole.
# Parameter order is: LON, LAT
my @BNA = (deg2rad(-86.67), deg2rad(90 - 36.12));
my @LAX = (deg2rad(-118.4), deg2rad(90 - 33.94));

print "Distance: ", great_circle_distance(@BNA, @LAX, 6372.8), " km\n";
