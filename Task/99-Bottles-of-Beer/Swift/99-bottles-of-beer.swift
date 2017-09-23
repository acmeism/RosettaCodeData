for i in (1...99).reversed() {
		print("\(i) bottles of beer on the wall, \(i) bottles of beer.")
		let next = i == 1 ? "no" : i.description
		print("Take one down and pass it around, \(next) bottles of beer on the wall.")
	}
