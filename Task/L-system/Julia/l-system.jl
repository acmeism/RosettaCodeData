using Lindenmayer

scurve = LSystem(Dict("F" => "F+F--F+F"), "8F--F--F") # 8 sets stroke width to 8 px
drawLSystem(scurve,
           forward = 16,
           turn = 60,
           startingx = -200,
           startingy = 100,
           iterations = 3,
           backgroundcolor = "white",
           filename = "kochsnow.png",
           showpreview = true
)

