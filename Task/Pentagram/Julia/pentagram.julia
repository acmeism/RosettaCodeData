using Luxor

function drawpentagram(path::AbstractString, w::Integer=1000, h::Integer=1000)
    Drawing(h, w, path)
    origin()
    setline(16)

    # To get a different color border from the fill, draw twice, first with fill, then without.
    sethue("aqua")
    star(0, 0, 500, 5, 0.39, 3pi/10, :fill)

    sethue("navy")
    verts = star(0, 0, 500, 5, 0.5, 3pi/10, vertices=true)
    poly([verts[i] for i in [1,5,9,3,7,1]], :stroke)
    finish()
    preview()
end

drawpentagram("data/pentagram.png")
