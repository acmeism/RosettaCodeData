using Printf

function drawpenrose()
    lindenmayer_rules = Dict("A" => "",
        "M" => "OA++PA----NA[-OA----MA]++", "N" => "+OA--PA[---MA--NA]+",
        "O" => "-MA++NA[+++OA++PA]-", "P" => "--OA++++MA[+PA++++NA]--NA")

    rul(x) = lindenmayer_rules[x]

    penrose = replace(replace(replace(replace("[N]++[N]++[N]++[N]++[N]",
        r"[AMNOP]" => rul), r"[AMNOP]" => rul), r"[AMNOP]" => rul), r"[AMNOP]" => rul)

    x, y, theta, r, svglines, stack = 160, 160, π / 5, 20.0, String[], Vector{Real}[]

    for c in split(penrose, "")
        if c == "A"
            xx, yy = x + r * cos(theta), y + r * sin(theta)
            line = @sprintf("<line x1='%.1f' y1='%.1f' x2='%.1f' y2='%.1f' style='stroke:rgb(255,165,0)'/>\n", x, y, xx, yy)
            x, y = xx, yy
            push!(svglines, line)
        elseif c == "+"
            theta += π / 5
        elseif c == "-"
            theta -= π / 5
        elseif c == "["
            push!(stack, [x, y, theta])
        elseif c == "]"
            x, y, theta = pop!(stack)
        end
    end

    svg = join(unique(svglines), "\n")
    fp = open("penrose_tiling.svg", "w")
    write(fp, """<svg xmlns="http://www.w3.org/2000/svg" height="350" width="350"> <rect height="100%" """ *
              """width="100%" style="fill:black" />""" * "\n$svg</svg>")
    close(fp)
end

drawpenrose()
