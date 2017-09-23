module FizzBuzz

augment java.lang.Integer {
	function getFizzAndOrBuzz = |this| -> match {
		when this % 15 == 0 then "FizzBuzz"
		when this % 3 == 0 then "Fizz"
		when this % 5 == 0 then "Buzz"
		otherwise this
	}
}

function main = |args| {
  foreach i in [1..101] {
	println(i: getFizzAndOrBuzz())
  }
}
