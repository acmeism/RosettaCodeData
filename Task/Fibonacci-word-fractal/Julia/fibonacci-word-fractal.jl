using Luxor, Colors

function fwfractal!(word::AbstractString, t::Turtle)
    left  =  90
    right = -90
    for (n, c) in enumerate(word)
        Forward(t)
        if c == '0'
            Turn(t, ifelse(iseven(n), left, right))
        end
    end
    return t
end

word = last(fiboword(25))

touch("data/fibonaccifractal.png")
Drawing(800, 800, "data/fibonaccifractal.png");
background(colorant"white")
t = Turtle(100, 300)
fwfractal!(word, t)
finish()
preview()
