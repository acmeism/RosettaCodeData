precedencegroup MonadPrecedence {
	higherThan: BitwiseShiftPrecedence
	associativity: left
}

infix operator >>-: MonadPrecedence	// Monadic bind

typealias Maybe = Optional

extension Maybe
{
	static func unit(_ x: Wrapped) -> Maybe<Wrapped>
	{
		return Maybe(x)
	}

	func bind<T>(_ f: (Wrapped) -> Maybe<T>) -> Maybe<T>
	{
		return self.flatMap(f)
	}

	static func >>- <U>(_ m: Optional<Wrapped>, _ f: (Wrapped) -> Maybe<U>) -> Maybe<U>
	{
		return m.flatMap(f)
	}
}

func dividedBy2IfEven(_ x: Int) -> Maybe<Int>
{
	x.isMultiple(of: 2) ? x / 2 : nil
}

func lineOfAs(_ x: Int) -> Maybe<String>
{
	guard x >= 0 else { return nil }
	let chars = Array<Character>(repeating: "A", count: x)
	return String(chars)
}

print("\(Maybe.unit(6).bind(dividedBy2IfEven).bind(lineOfAs) ?? "nil")")
print("\(Maybe.unit(4) >>- dividedBy2IfEven >>- lineOfAs ?? "nil")")
print("\(Maybe.unit(3) >>- dividedBy2IfEven >>- lineOfAs ?? "nil")")
print("\(Maybe.unit(-4) >>- dividedBy2IfEven >>- lineOfAs ?? "nil")")
