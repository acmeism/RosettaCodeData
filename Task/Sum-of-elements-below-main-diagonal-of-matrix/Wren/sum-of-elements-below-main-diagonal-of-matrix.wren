var m = [
    [ 1,  3,  7,  8, 10],
    [ 2,  4, 16, 14,  4],
    [ 3,  1,  9, 18, 11],
    [12, 14, 17, 18, 20],
    [ 7,  1,  3,  9,  5]
]
if (m.count != m[0].count) Fiber.abort("Matrix must be square.")
var sum = 0
for (i in 1...m.count) {
   for (j in 0...i) {
       sum = sum + m[i][j]
  }
}
System.print("Sum of elements below main diagonal is %(sum).")
