    // Utility for easy creation of Double from any Numeric
extension Double {
	init(withNum v: any Numeric) {
		switch v {
		case let ii as any BinaryInteger: self.init(ii)
		case let ff as any BinaryFloatingPoint: self.init(ff)
		default: self.init()
		}
	}
}
    // Extension for numeric collections
extension Collection where Element: Numeric {
	var arithmeticMean: Double {
		self.reduce(0.0, {$0 + Double(withNum: $1)})/Double(self.count)
	}
	var geometricMean: Double {
		pow(self.reduce(1.0, {$0 * Double(withNum: $1)}), 1.0/Double(self.count))
	}
	var harmonicMean: Double {
		Double(self.count) / self.reduce(0.0, {$0 + 1.0/Double(withNum:$1)})
	}
}
//Usage:
var c: [Int] = (1...10).map {$0}

print(c.arithmeticMean)
print(c.geometricMean)
print(c.harmonicMean)

// output:
// 5.5
// 4.528728688116765
// 3.414171521474055
