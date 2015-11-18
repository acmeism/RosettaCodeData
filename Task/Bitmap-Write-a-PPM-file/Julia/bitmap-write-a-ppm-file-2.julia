function writeppm(fn::String, a::Image)
    outf = open(fn, "w")
    (w, h) = size(a.pic)
    write(outf, "P6\n")
    write(outf, @sprintf "%d %d\n" w h)
    write(outf, @sprintf "%d\n" 255)
    for i in 1:h
        for j in 1:w
            c = color(a, j, i)
            write(outf, c.r)
            write(outf, c.g)
            write(outf, c.b)
        end
    end
    close(outf)
end
