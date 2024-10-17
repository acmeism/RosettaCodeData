using Lindenmayer # https://github.com/cormullion/Lindenmayer.jl

scurve = LSystem(Dict("X" => "XF-F+F-XF+F+XF-F+F-X"), "F+XF+F+XF")

drawLSystem(scurve,
    forward = 3,
    turn = 90,
    startingy = -400,
    iterations = 6,
    filename = "sierpinski_square_curve.png",
    showpreview = true
)
