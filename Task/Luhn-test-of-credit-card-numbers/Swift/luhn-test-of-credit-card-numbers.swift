func lunhCheck(number : String) -> Bool
{
	let reversedInts = number.characters.reversed().map { Int(String($0)) }
        return reversedInts.enumerated().reduce(0, {(sum, val) in
            let odd = val.offset % 2 == 1
            return sum + (odd ? (val.element! == 9 ? 9 : (val.element! * 2) % 9) : val.element!)
        }) % 10 == 0
}


lunhCheck("49927398716") // true
lunhCheck("49927398717") // false
