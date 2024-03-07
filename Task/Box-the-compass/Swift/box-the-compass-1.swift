import Foundation

extension Double {
	var nearestQr: Double {(self * 4.0).rounded(.toNearestOrAwayFromZero) / 4.0}
}

extension Measurement<UnitAngle>/*: ExpressibleByFloatLiteral*/ {
	var cos: Double { Darwin.cos(self.converted(to: .radians).value) }
	var sin: Double { Darwin.sin(self.converted(to: .radians).value) }
}

struct Compass {
	var bearing: Measurement<UnitAngle>
	var style: Style = .RN
	init(_ deg: Double, _ min: Double = 0, _ sec: Double = 0, style: Style = .RN
	) {
		self.bearing = .init(value: deg + min/60.0 + sec/360.0, unit: .degrees)
		self.style = style
	}
	static func degreesToPoints(_ deg: Double) -> Double {
		(deg/360 * 32).nearestQr
	}
	var point: Double {
		Self.degreesToPoints(self.bearing.value)
	}
	var quad: (String,String) {
		(bearing.cos < 0 ? "S" : "N", bearing.sin < 0 ? "W" : "E")
	}
	var step: (Int,Double) {
		let temp = 8 - abs(abs(self.point - 16) - 8)
		return (Int(temp),temp.truncatingRemainder(dividingBy: 1))
	}
	enum Style {case RN, USN, noBy}
	var formats = ["N", "NxE", "NNE", "NExN", "NE", "NExE", "ENE", "ExN", "E"]
	let fractions = ["¼","½","¾"]
	var invertedPoints: [Int] {
		switch self.style {
		case .RN: [3,6,7]
		case .USN: [3,7]
		case .noBy: [1,5,7]
		}
	}

	func named() -> String {
		var (pt,frac) = self.step
		var fracStr: String = ""
		if frac != 0.0 {
			if invertedPoints.contains(pt) {
				pt += 1
				fracStr = fractions.reversed()[Int(frac * 4) - 1] + "N"
			} else {
				fracStr = fractions[Int(frac * 4) - 1] + "E"
			}
		}
		return (self.formats[pt] + fracStr)
			.replacing(/(N|E)/) { $0.output.0 == "N" ? self.quad.0 : self.quad.1 }
			.replacing(/x/) {_ in "by"}
	}
}
