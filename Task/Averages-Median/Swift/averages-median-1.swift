    // Utility to aid easy type conversion
extension Double {
	init(withNum v: any Numeric) {
		switch v {
		case let ii as any BinaryInteger: self.init(ii)
		case let ff as any BinaryFloatingPoint: self.init(ff)
		default: self.init()
		}
	}
}

extension Array where Element: Numeric & Comparable {
        // Helper func for random element in range
	func randomElement(within: Range<Int>) -> Element {
		return self[.random(in: within)]
	}

	mutating func median() -> Double? {
		switch self.count {
		case 0: return nil
		case 1: return Double(withNum: self[0])
		case 2: return self.reduce(0, {sum,this in sum + Double(withNum: this)/2.0})
		default: break
		}
		let pTarget: Int = self.count / 2 + 1
		let resultSetLen: Int = self.count.isMultiple(of: 2) ? 2 : 1
		func divideAndConquer(bottom: Int, top: Int, goal: Int) -> Int {
			var (lower,upper) = (bottom,top)
			while true {
				let splitVal = self.randomElement(within: lower..<upper)
				let partitionIndex =  self.partition(subrange: lower..<upper, by: {$0 > splitVal})
				switch partitionIndex {
				case goal: return partitionIndex
				case ..<goal: lower = partitionIndex
				default: upper = partitionIndex
				}
			}
		}
			// Split just above the 'median point'
		var pIndex = divideAndConquer(bottom: 0, top: self.count, goal: pTarget)
			// Shove the highest 'low' values into the result slice
		pIndex = divideAndConquer(bottom: 0, top: pIndex, goal: pIndex - resultSetLen)
			// Average the contents of the result slice
		return self[pIndex..<pIndex + resultSetLen]
			.reduce(0.0, {sum,this in sum + Double(withNum: this)/Double(withNum: resultSetLen)})
	}
}
