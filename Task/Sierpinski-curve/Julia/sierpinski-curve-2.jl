using Lindenmayer # https://github.com/cormullion/Lindenmayer.jl

sierpcurve = LSystem(Dict("X" => "XF+G+XF--F--XF+G+X"), "F--XF--F--XF")

drawLSystem(sierpcurve,
    forward = 10,
    turn = 45,
    startingpen= (0.2, 0.8, 0.8),
    startingx = -380,
    startingy = 380,
    startingorientation = π/4,
    iterations = 5,
    filename = "sierpinski_curve.png",
    showpreview = true
)
