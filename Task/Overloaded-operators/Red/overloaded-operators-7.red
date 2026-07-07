Red [title: "Overloaded operators"]

+: make op! function [a b][
	case [
		all [string? a string? b] [return rejoin [a b]]
		all [string? a number? b] [return rejoin [a form b]]
		all [number? a string? b] [return add a load b]
		true [add a b] ; fall back to native operations
	]
]

print [10 + 20]
print ["hello" + " " + "world" + "!"]
print ["hi" + 5 + "!"]
print [10 + "20"]
