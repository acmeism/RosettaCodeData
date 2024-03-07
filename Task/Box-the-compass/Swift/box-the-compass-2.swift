let arr = [
	000.00, 016.87, 016.88, 033.75, 050.62, 050.63, 067.50, 084.37, 084.38,
	090.00, 101.25, 118.12, 118.13, 135.00, 151.87, 151.88, 168.75, 185.62,
	185.63, 202.50, 219.37, 219.38, 236.25, 253.12, 253.13, 270.00, 286.87,
	286.88, 303.75, 320.62, 320.63, 337.50, 354.37, 354.38
]

let arr2 = stride(from: 0, through: 360, by: 22.5/8.0)

let pointFormatter = NumberFormatter()
pointFormatter.minimumIntegerDigits = 2
pointFormatter.minimumFractionDigits = 2

for d in arr {
	let c = Compass(d, style: .RN)
	print(pointFormatter.string(from: c.point as NSNumber)!, c.dms , c.named())
}
