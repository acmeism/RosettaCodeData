do -- find the minimum number of coins needed to make a given value
   -- translated from the Wren sample

    local denoms = { 200, 100, 50, 20, 10, 5, 2, 1 }
    local amount = 988;
    local coins, remaining = 0, amount
    print( "The minimum number of coins needed to make a value of "..amount.." is as follows:" )
    for _, denom in pairs( denoms ) do
        local n = math.floor( remaining / denom )
        if n > 0 then
            coins = coins + n
            print( string.format( "%6d", denom ).." x "..n )
            remaining = remaining % denom
        end
        if remaining == 0 then break end
    end
    print( "A total of "..coins.." coins in all." )
end
