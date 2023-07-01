to rot13(textString)
    set theIDs to id of textString
    repeat with thisID in theIDs
        if (((thisID < 123) and (thisID > 96)) or ((thisID < 91) and (thisID > 64))) then ¬
            tell (thisID mod 32) to set thisID's contents to thisID - it + (it + 12) mod 26 + 1
    end repeat

    return string id theIDs
end rot13
