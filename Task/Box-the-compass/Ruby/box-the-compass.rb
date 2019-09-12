Headings = %w(north east south west north).each_cons(2).flat_map do |a, b|
  [a,
  "#{a} by #{b}",
  "#{a}-#{a}#{b}",
  "#{a}#{b} by #{a}",
  "#{a}#{b}",
  "#{a}#{b} by #{b}",
  "#{b}-#{a}#{b}",
  "#{b} by #{a}"]
end
Headings.prepend nil

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
