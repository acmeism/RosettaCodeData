extension BidirectionalCollection where Self: MutableCollection
{
	mutating func shuffleInPlace()
	{
		var index = self.index(before: self.endIndex)
		while index != self.startIndex
		{
			// Note the use of ... below. This makes the current element eligible for being selected
			let randomInt = Int.random(in: 0 ... self.distance(from: startIndex, to: index))
			let randomIndex = self.index(startIndex, offsetBy: randomInt)
			self.swapAt(index, randomIndex)
			index = self.index(before: index)
		}
	}
}

var a = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
a.shuffleInPlace()
print(a)
