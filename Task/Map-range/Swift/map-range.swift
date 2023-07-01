import Foundation

func mapRanges(_ r1: ClosedRange<Double>, _ r2: ClosedRange<Double>, to: Double) -> Double {
  let num = (to - r1.lowerBound) * (r2.upperBound - r2.lowerBound)
  let denom = r1.upperBound - r1.lowerBound

  return r2.lowerBound + num / denom
}

for i in 0...10 {
  print(String(format: "%2d maps to %5.2f", i, mapRanges(0...10, -1...0, to: Double(i))))
}
