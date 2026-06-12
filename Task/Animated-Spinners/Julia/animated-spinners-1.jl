""" https://rosettacode.org/wiki/Animated_Spinners """

using Luxor

const movie = Movie(600, 600, "lux_spinners")

function frame(scene::Scene, frame_num)
    rulers()
    sethue("grey40")
    rect(Point(-300, -300), 595, 595, action = :fill)
    sethue("black")
    circle(Point(0, 0), 296, action = :fill)
    colors = ["green", "orange", "red", "white", "yellow"]
    xs, ys = [0.0, 120.0, -120.0, 120.0, -120.0], [0.0, 120.0, -120.0, -120.0, 120.0]
    centers = [Point(xs[i], ys[i]) for i in eachindex(xs)]
    angle, r = mod1(frame_num * 7, 360), 84.0
    xs .= getindex.(centers, 1) .+ r * cospi(angle / 180)
    ys .= getindex.(centers, 2) .+ r * sinpi(angle / 180)
    for (i, c) in enumerate(centers)
        sethue(colors[i])
        setline(8)
        line(c, Point(xs[i], ys[i]), action = :stroke)
    end
end

animate(movie, [Scene(movie, frame, 1:720)], framerate = 1000, creategif = true, pathname = "lux_spinners.gif")
