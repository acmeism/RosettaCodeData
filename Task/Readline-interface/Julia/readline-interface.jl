function input(prompt::AbstractString)
    print(prompt)
    r = readline(STDIN)

    if isempty(r) || r == "quit"
        println("bye.")
    elseif r == "help"
        println("commands: ls, cat, quit")
    elseif r ∈ ("ls", "cat")
        println("command `$r` not implemented yet")
    else
        println("Yes...?")
    end
end

input("This is a common prompt> ")
