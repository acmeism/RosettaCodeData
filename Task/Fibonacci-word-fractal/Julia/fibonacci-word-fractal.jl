using Luxor, Colors

fiboword(n::Int) = n == 1 ? "1" : n == 2 ? "0" : fiboword(n - 1) * fiboword(n - 2)

function fwfractal!(word::AbstractString, t::Turtle)
	left  = 90
	right = -90
	for (n, c) in enumerate(word)
		Forward(t)
		if c == '0'
			Turn(t, ifelse(iseven(n), left, right))
		end
	end
	return t
end

word = fiboword(25)

touch("data/fibonaccifractal.png")
Drawing(520, 320, "data/fibonaccifractal.png");
background(colorant"white")
t = Turtle(50.0, 300.0)
fwfractal!(word, t)
finish()
preview()
