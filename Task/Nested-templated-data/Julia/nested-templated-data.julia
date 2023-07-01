t = ([Any[Any[1, 2],
          Any[3, 4, 1],
          5]])

p = ["Payload#$x" for x in 0:6]

for (i, e) in enumerate(t)
    if e isa Number
        t[i] = p[e + 1]
    else
        for (j, f) in enumerate(e)
            if f isa Number
                e[j] = p[f + 1]
            else
                for (k, g) in enumerate(f)
                    if g isa Number
                        f[k] = p[g + 1]
                    end
                end
            end
        end
    end
end


show(t)
