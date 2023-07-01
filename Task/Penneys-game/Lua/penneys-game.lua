function penny_game()
    local player, computer = "", ""
    function player_choose()
        io.write( "Enter your sequence of three H and/or T: " )
        local t = io.read():upper()
        if #t > 3 then t = t:sub( 1, 3 )
        elseif #t < 3 then return ""
        end

        for i = 1, 3 do
            c = t:sub( i, i )
            if c ~= "T" and c ~= "H" then
                print( "Just H's and T's!" )
                return ""
            end
        end
        return t
    end
    function computer_choose()
        local t = ""
        if #player > 0 then
            if player:sub( 2, 2 ) == "T" then
                t = "H"
            else
                t = "T";
            end
            t = t .. player:sub( 1, 2 )
        else
            for i = 1, 3 do
                if math.random( 2 ) == 1 then
                    t = t .. "H"
                else
                    t = t .. "T"
                end
            end
        end
        return t
    end
    if math.random( 2 ) == 1 then
        computer = computer_choose()
        io.write( "My sequence is: " .. computer .. "\n" )
        while( true ) do
            player = player_choose()
            if player:len() == 3 then break end
        end
    else
        while( true ) do
            player = player_choose()
            if player:len() == 3 then break end
        end
        computer = computer_choose()
        io.write( "My sequence is: " .. computer .. "\n" )
    end
    local coin, i = "", 1
    while( true ) do
        if math.random( 2 ) == 1 then
            coin = coin .. "T"
            io.write( "T" )
        else
            coin = coin .. "H"
            io.write( "H" )
        end
        if #coin > 2 then
            local seq = coin:sub( i, i + 2 )
            i = i + 1
            if seq == player then
                print( "\nPlayer WINS!!!" )
                return 1
            elseif seq == computer then
                print( "\nComputer WINS!!!" )
                return -1
            end
        end
    end
end
math.randomseed( os.time() )
local cpu, user = 0, 0
repeat
    r = penny_game()
    if r > 0 then
        user = user + 1
    else
        cpu = cpu + 1
    end
    print( "Player: " .. user .. " CPU: " .. cpu )
    io.write( "Play again (Y/N)? " )
    r = io.read()
until( r == "N" or r == "n" )
