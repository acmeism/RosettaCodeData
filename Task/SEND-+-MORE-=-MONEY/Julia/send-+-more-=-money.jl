let
    m = 1
    for s in 8:9
        for e in 0:9
            e in [m, s] && continue
            for n in 0:9
                n in [m, s, e] && continue
                for d in 0:9
                    d in [m, s, e, n] && continue
                    for o in 0:9
                        o in [m, s, e, n, d] && continue
                        for r in 0:9
                            r in [m, s, e, n, d, o] && continue
                            for y in 0:9
                                y in [m, s, e, n, d, o] && continue
                                if 1000s + 100e + 10n + d + 1000m + 100o + 10r + e ==
                                   10000m + 1000o + 100n + 10e + y
                                    println("$s$e$n$d + $m$o$r$e == $m$o$n$e$y")
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end
