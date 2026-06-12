function run_pathfinder()
    xp = 127
    yp = 127
    a = 0
    na = 0
    f = rand(0:3)
    x = Int[]
    y = Int[]
    e = Int[]
    entry = ""

    while true
        a = na
        for n in 1:na
            if x[n] == xp && y[n] == yp
                a = n
                break
            end
        end

        if a == na
            na += 1
            push!(x, xp)
            push!(y, yp)
            append!(e, zeros(Int,4))

            for n in 0:3
                e[4*a + n + 1] = rand(0:1)
            end

            for n in 1:na
                if x[n] == x[a+1] + 1 && y[n] == y[a+1]
                    e[4*a + 1] = e[4*(n-1) + 3]
                elseif x[n] == x[a+1] && y[n] == y[a+1] + 1
                    e[4*a + 2] = e[4*(n-1) + 4]
                elseif x[n] == x[a+1] - 1 && y[n] == y[a+1]
                    e[4*a + 3] = e[4*(n-1) + 1]
                elseif x[n] == x[a+1] && y[n] == y[a+1] - 1
                    e[4*a + 4] = e[4*(n-1) + 2]
                end
            end
        end

        print("Paths:")
        paths = [" ahead", " right", " back", " left"]
        for n in 0:3
            if e[4*a + ((f + n) % 4) + 1] == 1
                print(paths[n+1])
            end
        end
        println()

        d = -1
        while d < 0
            print("> ")
            entry = strip(readline())
            entry = lowercase(entry)

            if entry == "ahead"
                d = f % 4
            elseif entry == "right"
                d = (f + 1) % 4
            elseif entry == "back"
                d = (f + 2) % 4
            elseif entry == "left"
                d = (f + 3) % 4
            elseif entry == "quit"
                return
            else
                println("Invalid input.")
                continue
            end

            if d == 0
                if e[4*a + 1] == 1
                    xp += 1
                    f = d
                else
                    d = -1
                end
            elseif d == 1
                if e[4*a + 2] == 1
                    yp += 1
                    f = d
                else
                    d = -1
                end
            elseif d == 2
                if e[4*a + 3] == 1
                    xp -= 1
                    f = d
                else
                    d = -1
                end
            elseif d == 3
                if e[4*a + 4] == 1
                    yp -= 1
                    f = d
                else
                    d = -1
                end
            end

            if d < 0
                println("No path.")
            end
        end
    end
end

run_pathfinder()
