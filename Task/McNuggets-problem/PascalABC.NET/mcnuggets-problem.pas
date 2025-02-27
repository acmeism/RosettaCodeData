##
var nuggets := [0..100];
foreach var (x, y, z) in Cartesian(Range(0, 100 div 6), Range(0, 100 div 9), Range(0, 100 div 20)) do
  Exclude(nuggets, 6 * x + 9 * y + 20 * z);

nuggets.Max.println;
