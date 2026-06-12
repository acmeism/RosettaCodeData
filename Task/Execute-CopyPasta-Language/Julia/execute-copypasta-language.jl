function interpretCopyPasta()
    clipboard = String[]

    if isempty(ARGS)
        println("Usage: interpretcopypasta <filename>")
        exit(1)
    end

    thecode = read(ARGS[1], String)
    codelines = String.(strip.(split(thecode, "\n")))
    nextline() = popfirst!(codelines)

    Copy() = push!(clipboard, nextline())

    function CopyFile()
        txt = nextline()
        push!(clipboard, txt == "TheF*ckingCode" ? thecode : read(txt, String))
    end

    function Duplicate()
        ncopies, txt = parse(Int, nextline()), copy(clipboard)
        clipboard = foldl(vcat, [txt for _ in 1:ncopies])
    end

    Pasta!() = (for t in clipboard, x in split(t, "\n") println(x) end; exit(0))

    commands = Dict("Copy" => Copy, "CopyFile" => CopyFile,
        "Duplicate" => Duplicate, "Pasta!" => Pasta!)

    while !isempty(codelines)
        line = nextline()
        if haskey(commands, line)
            commands[line]()
        end
    end
end

interpretCopyPasta()
