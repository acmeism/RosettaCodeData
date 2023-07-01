on jewelsAndStones(stones, jewels)
    set counter to 0
    considering case
        repeat with thisCharacter in stones
            if (thisCharacter is in jewels) then set counter to counter + 1
        end repeat
    end considering

    return counter
end jewelsAndStones

jewelsAndStones("aAAbBbb", "aAb")
