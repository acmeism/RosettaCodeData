-- Perform weave shuffle
function shuffle (cards)
    local pile1, pile2 = {}, {}
    for card = 1, #cards / 2 do table.insert(pile1, cards[card]) end
    for card = (#cards / 2) + 1, #cards do table.insert(pile2, cards[card]) end
    cards = {}
    for card = 1, #pile1 do
        table.insert(cards, pile1[card])
        table.insert(cards, pile2[card])
    end
    return cards
end

-- Return boolean indicating whether or not the cards are in order
function inOrder (cards)
    for k, v in pairs(cards) do
        if k ~= v then return false end
    end
    return true
end

-- Count the number of shuffles needed before the cards are in order again
function countShuffles (deckSize)
    local deck, count = {}, 0
    for i = 1, deckSize do deck[i] = i end
    repeat
        deck = shuffle(deck)
        count = count + 1
    until inOrder(deck)
    return count
end

-- Main procedure
local testCases = {8, 24, 52, 100, 1020, 1024, 10000}
print("Input", "Output")
for _, case in pairs(testCases) do print(case, countShuffles(case)) end
