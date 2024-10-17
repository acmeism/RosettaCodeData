const starttxt = """

     ATTENTION ALL WUMPUS LOVERS!!!
     THERE ARE NOW TWO ADDITIONS TO THE WUMPUS FAMILY
     OF PROGRAMS.

      WUMP2:  SOME DIFFERENT CAVE ARRANGEMENTS
      WUMP3:  DIFFERENT HAZARDS

"""

const helptxt = """
     WELCOME TO 'HUNT THE WUMPUS'
      THE WUMPUS LIVES IN A CAVE OF 20 ROOMS. EACH ROOM
     HAS 3 TUNNELS LEADING TO OTHER ROOMS. (LOOK AT A
     DODECAHEDRON TO SEE HOW THIS WORKS-IF YOU DON'T KNOW
     WHAT A DODECAHEDRON IS, ASK SOMEONE)

         HAZARDS:
     BOTTOMLESS PITS - TWO ROOMS HAVE BOTTOMLESS PITS IN THEM
         IF YOU GO THERE, YOU FALL INTO THE PIT (& LOSE!)
     SUPER BATS - TWO OTHER ROOMS HAVE SUPER BATS. IF YOU
         GO THERE, A BAT GRABS YOU AND TAKES YOU TO SOME OTHER
         ROOM AT RANDOM. (WHICH MIGHT BE TROUBLESOME)

         WUMPUS:
     THE WUMPUS IS NOT BOTHERED BY THE HAZARDS (HE HAS SUCKER
     FEET AND IS TOO BIG FOR A BAT TO LIFT).  USUALLY
     HE IS ASLEEP. TWO THINGS WAKE HIM UP: YOUR ENTERING
     HIS ROOM OR YOUR SHOOTING AN ARROW.
         IF THE WUMPUS WAKES, HE MOVES (P=.75) ONE ROOM
     OR STAYS STILL (P=.25). AFTER THAT, IF HE IS WHERE YOU
     ARE, HE EATS YOU UP (& YOU LOSE!)

         YOU:
     EACH TURN YOU MAY MOVE OR SHOOT A CROOKED ARROW
       MOVING: YOU CAN GO ONE ROOM (THRU ONE TUNNEL)
       ARROWS: YOU HAVE 5 ARROWS. YOU LOSE WHEN YOU RUN OUT.
       EACH ARROW CAN GO FROM 1 TO 5 ROOMS. YOU AIM BY TELLING
       THE COMPUTER THE ROOM#S YOU WANT THE ARROW TO GO TO.
       IF THE ARROW CAN'T GO THAT WAY (IE NO TUNNEL) IT MOVES
       AT RANDOM TO THE NEXT ROOM.
         IF THE ARROW HITS THE WUMPUS, YOU WIN.
         IF THE ARROW HITS YOU, YOU LOSE.

        WARNINGS:
        WHEN YOU ARE ONE ROOM AWAY FROM WUMPUS OR HAZARD,
        THE COMPUTER SAYS:
     WUMPUS-  'I SMELL A WUMPUS'
     BAT   -  'BATS NEARBY'
     PIT   -  'I FEEL A DRAFT'

 """

function queryprompt(query, choices, choicetxt="")
    carr = map(x -> uppercase(strip(string(x))), collect(choices))
    while true
        print(query, " ", choicetxt == "" ? carr : choicetxt, ": ")
        choice = uppercase(strip(readline(stdin)))
        if choice in carr
            return choice
        end
        println()
    end
end

function wumpushunt(cheatmode = false)
    println(starttxt)
    arrows = 5
    rooms = Vector{Vector{Int}}()
    push!(rooms, [2,6,5], [3,8,1], [4,10,2], [5,2,3], [1,14,4], [15,1,7],
        [17,6,8], [7,2,9], [18,8,10], [9,3,11], [19,10,12], [11,4,13],
        [20,12,14], [5,11,13], [6,16,14], [20,15,17], [16,7,18],
        [17,9,19], [18,11,20], [19,13,16])
    roomcontents = shuffle(push!(fill("Empty", 15), "Bat", "Bat", "Pit", "Pit", "Wumpus"))
    randnextroom(room) = rand(rooms[room])
    newplayerroom(cr, range = 40) = (for i in 1:range cr = randnextroom(cr) end; cr)

    function senseroom(p)
        linkedrooms = rooms[p]
        if cheatmode
            println("linked rooms are $(rooms[p]), which have $(roomcontents[rooms[p][1]]),
                $(roomcontents[rooms[p][2]]), $(roomcontents[rooms[p][3]])")
        end
        if any(x -> roomcontents[x] == "Wumpus", linkedrooms)
            println("I SMELL A WUMPUS!")
        end
        if any(x -> roomcontents[x] == "Pit", linkedrooms)
            println("I FEEL A DRAFT")
        end
        if any(x -> roomcontents[x] == "Bat", linkedrooms)
            println("BATS NEARBY!")
        end
    end

    function arrowflight(arrowroom)
        if roomcontents[arrowroom] == "Wumpus"
            println("AHA! YOU GOT THE WUMPUS!")
            return("win")
        elseif any(x -> roomcontents[x] == "Wumpus", rooms[arrowroom])
            numrooms = rand([0, 1, 2, 3])
            if numrooms > 0
                println("...OOPS! BUMPED A WUMPUS!")
                wroom = rooms[arrowroom][findfirst(x -> roomcontents[x] == "Wumpus", rooms[arrowroom])]
                for i in 1:3
                    tmp = wroom
                    wroom = rand(rooms[wroom])
                    if wroom == playerroom
                        println("TSK TSK TSK- WUMPUS GOT YOU!")
                        return "lose"
                    else
                        roomcontents[tmp] = roomcontents[wroom]
                        roomcontents[wroom] = "Wumpus"
                    end
                end
            end
        elseif arrowroom == playerroom
            println("OUCH! ARROW GOT YOU!")
            return "lose"
        end
        return ""
    end

    println("HUNT THE WUMPUS")
    playerroom = 1
    while true
        playerroom = newplayerroom(playerroom)
        if roomcontents[playerroom] == "Empty"
            break
        end
    end
    while arrows > 0
        senseroom(playerroom)
        println("YOU ARE IN ROOM $playerroom. TUNNELS LEAD TO ", join(rooms[playerroom], ";"))
        choice = queryprompt("SHOOT OR MOVE (H FOR HELP)", ["S", "M", "H"])
        if choice == "M"
            choice = queryprompt("WHERE TO", rooms[playerroom])
            playerroom = parse(Int, choice)
            if roomcontents[playerroom] == "Wumpus"
                println("TSK TSK TSK- WUMPUS GOT YOU!")
                return "lose"
            elseif roomcontents[playerroom] == "Pit"
                println("YYYIIIIEEEE . . . FELL IN PIT")
                return "lose"
            elseif roomcontents[playerroom] == "Bat"
                senseroom(playerroom)
                println("ZAP--SUPER BAT SNATCH! ELSEWHEREVILLE FOR YOU!")
                playerroom = newplayerroom(playerroom, 10)
            end
        elseif choice == "S"
            distance = parse(Int, queryprompt("NO. OF ROOMS(1-5)", 1:5))
            choices = zeros(Int, 5)
            arrowroom = playerroom
            for i in 1:distance
                choices[i] = parse(Int, queryprompt("ROOM #", 1:20, "1-20"))
                while i > 2 && choices[i] == choices[i-2]
                    println("ARROWS AREN'T THAT CROOKED - TRY ANOTHER ROOM")
                    choices[i] = parse(Int, queryprompt("ROOM #", 1:20, "1-20"))
                end
                arrowroom = choices[i]
            end
            arrowroom = playerroom
            for rm in choices
                if rm != 0
                    if !(rm in rooms[arrowroom])
                        rm = rand(rooms[arrowroom])
                    end
                    arrowroom = rm
                    if (ret = arrowflight(arrowroom)) != ""
                        return ret
                    end
                end
            end
            arrows -= 1
            println("MISSED")
        elseif choice == "H"
            println(helptxt)
        end
    end
    println("OUT OF ARROWS.\nHA HA HA - YOU LOSE!")
    return "lose"
end

while true
    result = wumpushunt()
    println("Game over. You $(result)!")
    if queryprompt("Play again?", ["Y", "N"]) == "N"
        break
    end
end
