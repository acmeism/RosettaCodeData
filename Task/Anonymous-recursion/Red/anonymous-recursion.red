Red [
	Title: "Annonymous Recursion"
	Purpose: {
		Showing annonymous recursion call using custom lambda function in Red.
		NOTE: "Lambda" create a function on the fly with a special reference to itself (named "recurse").
			"Compose" and "reduce" are Red's construct to build data into an evaluatable block, "print" then
			evaluate it and execute the function directly.
	}
	Author: "hinjolicious"
	Credits: "Red/Sensei"
]

lambda: func [spec body /local ctx][
    ctx: make object! [recurse: none]
    ctx/recurse: func spec bind body ctx
    :ctx/recurse
]

print compose [(
	lambda [n][either n <= 2 [1][
		(recurse n - 1) + (recurse n - 2)
	]])
	10
]

print reduce [
	lambda [n][either n <= 2 [1][
		(recurse n - 1) + (recurse n - 2)
	]]
	20
]

