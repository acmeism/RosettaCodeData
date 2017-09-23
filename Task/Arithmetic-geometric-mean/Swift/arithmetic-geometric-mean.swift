import Darwin

enum AGRError : Error {
	case undefined
}

func agm(_ a: Double, _ g: Double, _ iota: Double = 1e-8) throws -> Double {
	var a = a
	var g = g
	var a1: Double = 0
	var g1: Double = 0
	
	guard a * g >= 0 else {
		throw AGRError.undefined
	}
	
	while abs(a - g) > iota {
		a1 = (a + g) / 2
		g1 = sqrt(a * g)
		a = a1
		g = g1
	}
	
	return a
}

do {
	try print(agm(1, 1 / sqrt(2)))
} catch {
	print("agr is undefined when a * g < 0")
}
