def point_inside_triangle (p, a, b, c)
  side_of_line(p, a, b) == side_of_line(p, b, c) == side_of_line(p, c, a)
end

def side_of_line (p, a, b)
  ((b[0] - a[0]) * (p[1] - a[1]) - (b[1] - a[1]) * (p[0] - a[0])).sign
end

p! point_inside_triangle({0, 0}, {1.5, 2.4}, {5.1, -3.1}, {-3.8, 1.2}),
   point_inside_triangle({0, 1}, {1.5, 2.4}, {5.1, -3.1}, {-3.8, 1.2}),
   point_inside_triangle({3, 1}, {1.5, 2.4}, {5.1, -3.1}, {-3.8, 1.2}),
   point_inside_triangle({5.414286, 14.349206}, {0.1, 0.111111}, {12.5, 33.333333}, {25.0, 11.111111}),
   point_inside_triangle({5.414286, 14.349206}, {0.1, 0.111111}, {12.5, 33.333333}, {-12.5, 16.666667})
