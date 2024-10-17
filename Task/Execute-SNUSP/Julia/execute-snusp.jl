const echo2 =  raw"""
       /==!/======ECHO==,==.==#
       |   |
$==>==@/==@/==<==#"""

@enum Direction left up right down

function snusp(datalength, progstring)
    stack = Vector{Tuple{Int, Int, Direction}}()
    data = zeros(datalength)
    dp = ipx = ipy = 1
    direction = right    # default to go to right at beginning

    lines = split(progstring, "\n")
    lmax = maximum(map(length, lines))
    lines = map(x -> rpad(x, lmax), lines)
    for (y, li) in enumerate(lines)
        if (x = findfirst("\$", li)) != nothing
            (ipx, ipy) = (x[1], y)
        end
    end

    instruction = Dict([('>', ()-> dp += 1),
        ('<', ()-> (dp -= 1; if dp < 0 running = false end)), ('+', ()-> data[dp] += 1),
        ('-', ()-> data[dp] -= 1), (',', ()-> (data[dp] = read(stdin, UInt8))),
        ('.', ()->print(Char(data[dp]))),
        ('/', ()-> (d = Int(direction); d += (iseven(d) ? 3 : 5); direction = Direction(d % 4))),
        ('\\', ()-> (d = Int(direction); d += (iseven(d) ? 1 : -1); direction = Direction(d))),
        ('!', () -> ipnext()), ('?', ()-> if data[dp] == 0 ipnext() end),
        ('@', ()-> push!(stack, (ipx, ipy, direction))),
        ('#', ()-> if length(stack) > 0 (ipx, ipy, direction) = pop!(stack) end),
        ('\n', ()-> (running = false))])

    inboundsx(plus) = (plus ? (ipx < lmax) : (ipx > 1)) ? true : exit(data[dp])
    inboundsy(plus) = (plus ? (ipy < length(lines)) : (ipy > 1)) ? true : exit(data[dp])
    function ipnext()
        if direction == right && inboundsx(true)     ipx += 1
        elseif direction == left && inboundsx(false) ipx -= 1
        elseif direction == down && inboundsy(true)  ipy += 1
        elseif direction == up && inboundsy(false)   ipy -= 1
        end
    end

    running = true
    while running
        cmdcode = lines[ipy][ipx]
        if haskey(instruction, cmdcode)
            instruction[cmdcode]()
        end
        ipnext()
    end
    exit(data[dp])
end

snusp(100, echo2)
