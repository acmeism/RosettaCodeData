""" Rosetta Code task Compiler/Preprocessor task """

""" If the line is a macro definition, add the macro to macros. """
function addmacro!(macros, line)
    macroname, comment = "", ""
    if (m = match(r"#define\s+(\w[\w\d]*)\(([^\)]+)\)\s+(.+)", line)) != nothing
        macroname, argstring, definition = m.captures
        comment = "/* Define $macroname($argstring) as $definition */\n"
        @assert !haskey(macros, macroname) "Duplicate macro names are not allowed"
        argv = strip.(split(argstring, r"\s*,\s*"))
        @assert allunique(argv) "Parameter argument symbols must be different from each other"
        def = " " * definition
        defstrings, argnums = String[], Int[]
        for m in reverse(collect(eachmatch(Regex(join(argv, "|")), def)))
            cutposition = m.offset + length(m.match)
            pushfirst!(defstrings, def[begin+cutposition-1:end])
            pushfirst!(argnums, findfirst(==(m.match), argv))
            def = def[begin:m.offset-1]
        end
        pushfirst!(defstrings, def)
        macros[macroname] = (defstrings, argnums)
    elseif (m = match(r"#define\s+(\w[\w\d]*)(?:\(\))?\s+(.+)", line)) != nothing
        macroname, definition = m.captures
        comment = "/* Define $macroname as $definition */\n"
        macros[macroname] = ([string(definition)], Int[])
    else
        return false, ""
    end
    return true, comment
end

""" If the line contains macro or macros, substitute all and return results. """
function replaceifmacro(macros, line; withinhashtag = true)
    replacedline, allmacronames, usedmacros = line, join(keys(macros), "|"), String[]
    for m in reverse(
        collect(
            eachmatch(
                Regex(
                    withinhashtag ? "#(" * allmacronames * raw")(?:(?:\(([^\)]+)\)#)|#)" :
                    "(" * allmacronames * raw")(?:(?:\(([^\)]+)\))?)",
                ),
                replacedline,
            ),
        ),
    )
        push!(usedmacros, string(m.captures[1]))
        if m.offsets[end] != 0 # has arguments
            args = split(m.captures[end], r"\s*,\s*")
            for (i, arg) in enumerate(args)
                used, newtext = replaceifmacro(macros, arg; withinhashtag = false)
                if !isempty(used)
                    submacro = first(used)
                    push!(usedmacros, submacro)
                    args[i] = macros[submacro][1][1]
                end
            end
            strings, nums = macros[m.captures[1]]
            s =
                first(strings) *
                prod([args[n] * strings[i+1] for (i, n) in enumerate(nums)])
            replacedline =
                replacedline[begin:m.offsets[1]-2] *
                s *
                replacedline[m.offset+length(m.match):end]
        else
            replacedline =
                replacedline[begin:m.offsets[1]-2] *
                macros[m.captures[1]][1][1] *
                replacedline[m.offset+length(m.match):end]
        end
    end
    return usedmacros, replacedline
end

""" If a line starts with #include, return the lines in the include file. """
function processinclude(line)
    lines, fname = String[], ""
    if (m = match(r"#include\s+\"([^\"]+)\"", line)) != nothing
        fname = first(m.captures)
        lines = readlines(fname, keep = true)
    end
    return fname, lines
end

""" Preprocess the file to prepare it for the Rosetta Code lexical analyzer task. """
function preprocess(instream, outstream, debug)
    lines = readlines(instream, keep = true)
    macros = Dict{String,Tuple{Vector{String},Vector{Int}}}()
    linesread = 0
    while !isempty(lines)
        line = popfirst!(lines)
        linesread += 1
        if startswith(line, '#')
            fname, includelines = processinclude(line)
            if !isempty(fname)
                if debug
                    pushfirst!(includelines, """/* Include $fname */\n""")
                    push!(includelines, """/* End $fname */\n""")
                end
                lines = append!(includelines, lines)
            elseif startswith(line, r"#define\s")
                gotmacro, comment = addmacro!(macros, line)
                gotmacro && debug && print(outstream, comment)
            else
                error("Unknown preprocessor directive in line: $line")
            end
        else
            usedmacros, replacedline = replaceifmacro(macros, line)
            if !isempty(usedmacros)
                debug && print(outstream, "/* Used " * join(usedmacros, ", ", " and ") * " */\n")
                line = replacedline
            end
            print(outstream, line)
        end
    end
    return linesread
end

""" Process command line, open files if needed, hand off to function `func`, close files """
function runwithopts(func, minargs = 0, maxargs = 3)
    minargs <= length(ARGS) <= maxargs || error("Wrong number of arguments ($minargs:$maxargs)")
    debug, infile, outfile = false, "", ""
    for arg in ARGS
        if arg == "-d" || arg == "-debug"
            debug = true
        elseif isempty(infile)
            infile = arg
        elseif isempty(outfile)
            outfile = arg
        end
    end
    ioin = isempty(infile) ? stdin : open(infile, "r")
    ioout = isempty(outfile) ? stdout : open(outfile, "w")

    func(ioin, ioout, debug)
    !isempty(infile) && close(ioin)
    !isempty(outfile) && close(ioout)
end

runwithopts(preprocess)
