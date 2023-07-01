extension Int
{
	func isPrime() -> Bool
	{
		if self < 3
		{
			return self == 2
		}
		else
		{
			let upperLimit = Int(Double(self).squareRoot())
			return !self.isMultiple(of: 2) && !stride(from: 3, through: upperLimit, by: 2)
				.contains(where: { factor in self.isMultiple(of: factor) })
		}
	}
}
