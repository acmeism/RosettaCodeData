Headings = {
  1 => "north",
  2 => "north by east",
  3 => "north-northeast",
  4 => "northeast by north",
  5 => "northeast",
  6 => "northeast by east",
  7 => "east-northeast",
  8 => "east by north",
  9 => "east",
  10 => "east by south",
  11 => "east-southeast",
  12 => "southeast by east",
  13 => "southeast",
  14 => "southeast by south",
  15 => "south-southeast",
  16 => "south by east",
  17 => "south",
  18 => "south by west",
  19 => "south-southwest",
  20 => "southwest by south",
  21 => "southwest",
  22 => "southwest by west",
  23 => "west-southwest",
  24 => "west by south",
  25 => "west",
  26 => "west by north",
  27 => "west-northwest",
  28 => "northwest by west",
  29 => "northwest",
  30 => "northwest by north",
  31 => "north-northwest",
  32 => "north by west",
}

# Finds the 32-point compass heading nearest _degrees_, and
# returns an array of the index and name.
#
#   p heading(60)
#   # => [6, "northeast by east"]
#
def heading(degrees)
  i = degrees.quo(360).*(32).round.%(32).+(1)
  [i, Headings[i]]
end

# an array of angles, in degrees
angles = (0..32).map { |i| i * 11.25 + [0, 5.62, -5.62][i % 3] }

angles.each do |degrees|
  index, name = heading degrees
  printf "%2d %20s %6.2f\n", index, name.center(20), degrees
end
