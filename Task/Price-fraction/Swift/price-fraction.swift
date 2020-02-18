let ranges = [
  (0.00..<0.06, 0.10),
  (0.06..<0.11, 0.18),
  (0.11..<0.16, 0.26),
  (0.16..<0.21, 0.32),
  (0.21..<0.26, 0.38),
  (0.26..<0.31, 0.44),
  (0.31..<0.36, 0.50),
  (0.36..<0.41, 0.54),
  (0.41..<0.46, 0.58),
  (0.46..<0.51, 0.62),
  (0.51..<0.56, 0.66),
  (0.56..<0.61, 0.70),
  (0.61..<0.66, 0.74),
  (0.66..<0.71, 0.78),
  (0.71..<0.76, 0.82),
  (0.76..<0.81, 0.86),
  (0.81..<0.86, 0.90),
  (0.86..<0.91, 0.94),
  (0.91..<0.96, 0.98),
  (0.96..<1.01, 1.00)
]

func adjustDouble(_ val: Double, accordingTo ranges: [(Range<Double>, Double)]) -> Double? {
  return ranges.first(where: { $0.0.contains(val) })?.1
}

for val in stride(from: 0.0, through: 1, by: 0.01) {
  let strFmt = { String(format: "%.2f", $0) }

  print("\(strFmt(val)) -> \(strFmt(adjustDouble(val, accordingTo: ranges) ?? val))")
}
