range(100) + 1 | [(
	(select(. % 3 == 0) | "Fizz"),
	(select(. % 5 == 0) | "Buzz")
) // tostring] | join("")
