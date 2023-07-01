(
var n = 100, doors = false ! n;
var pass = { |j| (0, j .. n-1).do { |i| doors[i] = doors[i].not } };
(1..n-1).do(pass);
doors.selectIndices { |open| open }; // all are closed except [ 0, 1, 4, 9, 16, 25, 36, 49, 64, 81 ]
)
