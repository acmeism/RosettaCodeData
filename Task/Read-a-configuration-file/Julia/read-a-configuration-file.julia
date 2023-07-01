function readconf(file)
    vars = Dict()
    for line in eachline(file)
        line = strip(line)
        if !isempty(line) && !startswith(line, '#') && !startswith(line, ';')
            fspace  = searchindex(line, " ")
            if fspace == 0
                vars[Symbol(lowercase(line))] = true
            else
                vname, line = Symbol(lowercase(line[1:fspace-1])), line[fspace+1:end]
                value = ',' ∈ line ? strip.(split(line, ',')) : line
                vars[vname] = value
            end
        end
    end
    for (vname, value) in vars
        eval(:($vname = $value))
    end
    return vars
end

readconf("test.conf")

@show fullname favouritefruit needspeeling otherfamily
