function cleansyntax(line)
    line = strip(line)
    if line == ""
        return "#=blank line=#"
    elseif line[1] == '#'
        return line
    elseif line[1] == ';'
        line = replace(line, r"^;[;]+" => ";")
    else # active option
        o, p = splitline(line)
        line = p == nothing ? uppercase(o) : uppercase(o) * " " * p
    end
    join(filter(c -> isascii(c[1]) && !iscntrl(c[1]), split(line, "")), "")
end

"""
    Run to clean up the configuration file lines prior to other function application.
"""
cleansyntax!(lines) = (for (i, li) in enumerate(lines) lines[i] = cleansyntax(li) end; lines)

isdisabled(line) = startswith(line, [';', '#'])
isenabled(line) = !isdisabled(line)

function splitline(line)
    arr = split(line, r"\s+", limit=2)
    if length(arr) < 2
        return (arr[1], nothing)
    end
    return (arr[1], arr[2])
end

function disable!(lines, opt)
    for (i, li) in enumerate(lines)
        if isenabled(li) && splitline(li)[1] == uppercase(opt)
            lines[i] = ";" * li
            break # note: only first one found is disabled
        end
    end
    lines
end

function enable!(lines, opt)
    for (i, li) in enumerate(lines)
        if isdisabled(li)
            s = li[2:end]
            if splitline(s)[1] == uppercase(opt)
                lines[i] = s
                break # note: only first one found is enabled
            end
        end
    end
    lines
end

function changeparam!(lines, opt, newparam)
    for (i, li) in enumerate(lines)
        if isenabled(li)
            o, p = splitline(li)
            if o == opt
                lines[i] = o * " " * string(newparam)
                break # note: only first one found is changed
            end
        end
    end
    lines
end

function activecfg(lines)
    cfgdict = Dict()
    for li in lines
        if isenabled(li)
            o, p = splitline(li)
            cfgdict[o] = p
        end
    end
    cfgdict
end

const filename = "fruit.cfg"
const cfh = open(filename)
const cfglines = cleansyntax!(readlines(cfh))
close(cfh)

const cfg = activecfg(cfglines)

disable!(cfglines, "NEEDSPEELING")
enable!(cfglines, "SEEDSREMOVED")
changeparam!(cfglines, "NUMBEROFBANANAS", 1024)

if !haskey(cfg, "NUMBEROFSTRAWBERRIES")
    push!(cfglines, "NUMBEROFSTRAWBERRIES 62000")
end
cfg["NUMBEROFSTRAWBERRIES"] = 62000
changeparam!(cfglines, "NUMBEROFSTRAWBERRIES", 62000)

const cfw = open(filename, "w")
for li in cfglines
    if li != ""
        if li == "#=blank line=#"
            li = ""
        end
        write(cfw, li * "\n")
    end
end
