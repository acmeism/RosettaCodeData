module Bottles

augment java.lang.Integer {
	function bottles = |self| -> match {
		when self == 0 then "No bottles"
		when self == 1 then "One bottle"
		otherwise self + " bottles"
	}
}

function main = |args| {
	99: downTo(1, |i| {
		println(i: bottles() + " of beer on the wall,")
		println(i: bottles() + " of beer!")
		println("Take one down, pass it around,")
		println((i - 1): bottles() + " of beer on the wall!")
		println("--------------------------------------")
	})
}
