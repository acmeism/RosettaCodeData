-- Return a table respresenting a standard deck of cards in order
function newDeck ()
    local cards, suits = {}, {"C", "D", "H", "S"}
    for _, suit in pairs(suits) do
        for value = 2, 14 do
            if value == 10 then value = "T" end
            if value == 11 then value = "J" end
            if value == 12 then value = "Q" end
            if value == 13 then value = "K" end
            if value == 14 then value = "A" end
            table.insert(cards, value .. suit)
        end
    end
    return cards
end

-- Display all cards (strings) in a given deck (table)
function show (deck)
    for _, card in pairs(deck) do io.write(card .. " ") end
    print("\n")
end

-- Perform a riffle shuffle on deck and return it as a new table
function riffle (deck)
    local pile1, pile2, pos = {}, {}, 1
    for i, card in ipairs(deck) do
        if i < math.ceil(#deck / 2) + 1 then
            table.insert(pile1, card)
        else
            table.insert(pile2, card)
        end
    end
    deck = {}
    while pile2[pos] do
        table.insert(deck, pile1[pos])
        table.insert(deck, pile2[pos])
        pos = pos + 1
    end
    return deck
end

-- Perform an overhand shuffle on a deck and return it as a new table
function overhand (deck)
    local newDeck, twentyPercent, groupSize, pos = {}, math.floor(#deck / 5)
    repeat
        repeat
            groupSize = math.random(twentyPercent)
        until groupSize <= #deck
        for pos = #deck - groupSize, #deck do
            table.insert(newDeck, deck[pos])
            deck[pos] = nil
        end
    until #deck == 0
    return newDeck
end

-- Main procedure
math.randomseed(os.time())
local deck1, deck2 = newDeck(), newDeck()
deck1 = riffle(deck1)
print("Sorted deck after one riffle shuffle:")
show(deck1)
deck2 = overhand(deck2)
print("Sorted deck after one overhand shuffle:")
show(deck2)
