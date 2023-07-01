tp = [Point(0.1234, 0.9876),
      Point(0.0000, 2.0000),
      Point(0.1234, 0.9876),
      Point(0.1234, 0.9876),
      Point(0.1234, 0.9876)]

tq = [Point(0.8765, 0.2345),
      Point(0.0000, 0.0000),
      Point(0.1234, 0.9876),
      Point(0.8765, 0.2345),
      Point(0.1234, 0.9876)]

tr = [2.0, 1.0, 2.0, 0.5, 0.0]

println("Testing circlepoints:")
for i in 1:length(tp)
    p = tp[i]
    q = tq[i]
    r = tr[i]
    (cp, rstatus) = circlepoints(p, q, r)
    println(@sprintf("(%.4f, %.4f), (%.4f, %.4f), %.4f => %s",
                     p.x, p.y, q.x, q.y, r, rstatus))
    for c in cp
        println(@sprintf("    (%.4f, %.4f), %.4f",
                         c.c.x, c.c.y, c.r))
    end
end
