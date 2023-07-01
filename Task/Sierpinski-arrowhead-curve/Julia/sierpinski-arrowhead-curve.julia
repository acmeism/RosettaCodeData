using Lindenmayer # https://github.com/cormullion/Lindenmayer.jl

scurve = LSystem(Dict("F" => "G+F+Gt", "G"=>"F-G-F"), "G")

drawLSystem(scurve,
    forward = 3,
    turn = 60,
    startingy = -350,
    iterations = 8,
    startingorientation = π/3,
    filename = "sierpinski_arrowhead_curve.png",
    showpreview = true
)
