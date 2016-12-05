func lunhCheck(number : String) -> Bool
{
	let reversedInts = number.characters.reverse().map { Int(String($0)) }
	return reversedInts.enumerate().reduce(0, combine: {(sum, val) in
		let odd = val.index % 2 == 1
		return sum + (odd ? (val.element! == 9 ? 9 : (val.element! * 2) % 9) : val.element!)
	}) % 10 == 0
}


lunhCheck("49927398716") // true
lunhCheck("49927398717") // false
