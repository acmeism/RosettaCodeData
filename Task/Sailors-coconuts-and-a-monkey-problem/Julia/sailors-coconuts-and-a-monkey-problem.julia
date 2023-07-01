function validnutsforsailors(sailors, finalpile)
    for i in sailors:-1:1
        if finalpile % sailors != 1
            return false
        end
        finalpile -= Int(floor(finalpile/sailors) + 1)
    end
    (finalpile != 0) && (finalpile % sailors == 0)
end

function runsim()
    println("Sailors     Starting Pile")
    for sailors in 2:9
        finalcount = 0
        while validnutsforsailors(sailors, finalcount) == false
            finalcount += 1
        end
        println("$sailors           $finalcount")
    end
end

runsim()
