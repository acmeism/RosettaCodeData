// z-combinator

z = { |f| { |x| f.({ |args| x.(x).(args) }) }.({ |x| f.({ |args| x.(x).(args) }) }) };

// this can be also factored differently
(
y = { |f|
	{ |r| r.(r) }.(
		{ |x| f.({ |args| x.(x).(args) }) }
	)
};
)

// the same in a reduced form

(
r = { |x| x.(x) };
z = { |f| r.({ |y| f.(r.(y).(_)) }) };
)


// factorial
k = { |f| { |x| if(x < 2, 1, { x * f.(x - 1) }) } };

g = z.(k);

g.(5) // 120

(1..10).collect(g) // [ 1, 2, 6, 24, 120, 720, 5040, 40320, 362880, 3628800 ]



// fibonacci

k = { |f| { |x| if(x <= 2, 1, { f.(x - 1) + f.(x - 2) }) } };

g = z.(k);

g.(3)

(1..10).collect(g) // [ 1, 1, 2, 3, 5, 8, 13, 21, 34, 55 ]
