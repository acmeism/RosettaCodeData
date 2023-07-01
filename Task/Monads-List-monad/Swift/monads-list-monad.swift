precedencegroup MonadPrecedence {
	higherThan: BitwiseShiftPrecedence
	associativity: left
}

infix operator >>-: MonadPrecedence	// Monadic bind

extension Array
{
	static func unit(_ x: Element) -> [Element]
	{
		return [x]
	}

	func bind<T>(_ f: (Element) -> [T]) -> [T]
	{
		return flatMap(f)
	}

	static func >>- <U>(_ m: [Element], _ f: (Element) -> [U]) -> [U]
	{
		return m.flatMap(f)
	}
}

func adjacent(_ x: Int) -> [Int]
{
	[x - 1, x + 1]
}

func squareRoots(_ x: Int) -> [Double]
{
	guard x >= 0 else { return [] }
	return [Double(x).squareRoot(), -(Double(x).squareRoot())]
}

print("\([Int].unit(8).bind(adjacent).bind(squareRoots))")
print("\([Int].unit(8) >>- adjacent >>- squareRoots)")
print("\([Int].unit(0) >>- adjacent >>- squareRoots)")
