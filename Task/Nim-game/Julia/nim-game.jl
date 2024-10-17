function nimgame()
    tcount = 12
    takenum = 0
    while true
        while true
            permitted = collect(1:min(3,tcount))
            println("$tcount tokens remain.\nHow many do you take ($permitted)? ")
            takenum = parse(Int, strip(readline(stdin)))
            if takenum in permitted
                break
            end
        end
        tcount -= 4
        println("Computer takes $(4 - takenum). There are $tcount tokens left.")
        if tcount < 1
            println("Computer wins as expected.")
            break
        end
    end
end

nimgame()
