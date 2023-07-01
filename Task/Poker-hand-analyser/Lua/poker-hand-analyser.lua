-- Check whether t is a valid poker hand
function valid (t)
    if #t ~= 5 then return false end
    for k, v in pairs(t) do
        for key, card in pairs(t) do
            if  v.value == card.value and
                v.suit == card.suit and
                k ~= key
            then
                return false
            end
        end
    end
    return true
end

-- Return numerical value of a single card
function cardValue (card)
    local val = card:sub(1, -2)
    local n = tonumber(val)
    if n then return n end
    if val == "j" then return 11 end
    if val == "q" then return 12 end
    if val == "k" then return 13 end
    if val == "a" then return 1 end
    error("Invalid card value: " .. val)
end

-- Detect whether hand t is a straight
function straight (t)
    table.sort(t, function (a, b) return a.value < b.value end)
    local ace, thisValue, lastValue = false
    for i = 2, #t do
        thisValue, lastValue = t[i].value, t[i-1].value
        if lastValue == 1 then ace = i - 1 end
        if thisValue ~= lastValue + 1 then
            if ace then
                t[ace].value = 14
                return straight(t)
            else
                return false
            end
        end
    end
    return true
end

-- Detect whether hand t is a flush
function isFlush (t)
    local suit = t[1].suit
    for card = 2, #t do
        if t[card].suit ~= suit then return false end
    end
    return true
end

-- Return a table of the count of each card value in hand t
function countValues (t)
    local countTab, maxCount = {}, 0
    for k, v in pairs(t) do
        if countTab[v.value] then
            countTab[v.value] = countTab[v.value] + 1
        else
            countTab[v.value] = 1
        end
    end
    return countTab
end

-- Find the highest value in t
function highestCount (t)
    local maxCount = 0
    for k, v in pairs(t) do
        if v > maxCount then maxCount = v end
    end
    return maxCount
end

-- Detect full-house and two-pair using the value counts in t
function twoTypes (t)
    local threes, twos = 0, 0
    for k, v in pairs(t) do
        if v == 3 then threes = threes + 1 end
        if v == 2 then twos = twos + 1 end
    end
    return threes, twos
end

-- Return the rank of a poker hand represented as a string
function rank (cards)
    local hand = {}
    for card in cards:gmatch("%S+") do
        table.insert(hand, {value = cardValue(card), suit = card:sub(-1, -1)})
    end
    if not valid(hand) then return "invalid" end
    local st, fl = straight(hand), isFlush(hand)
    if st and fl then return "straight-flush" end
    local valCount = countValues(hand)
    local highCount = highestCount(valCount)
    if highCount == 4 then return "four-of-a-kind" end
    local n3, n2 = twoTypes(valCount)
    if n3 == 1 and n2 == 1 then return "full-house" end
    if fl then return "flush" end
    if st then return "straight" end
    if highCount == 3 then return "three-of-a-kind" end
    if n3 == 0 and n2 == 2 then return "two-pair" end
    if highCount == 2 then return "one-pair" end
    return "high-card"
end

-- Main procedure
local testCases = {
    "2h 2d 2c kc qd", -- three-of-a-kind
    "2h 5h 7d 8c 9s", -- high-card
    "ah 2d 3c 4c 5d", -- straight
    "2h 3h 2d 3c 3d", -- full-house
    "2h 7h 2d 3c 3d", -- two-pair
    "2h 7h 7d 7c 7s", -- four-of-a-kind
    "10h jh qh kh ah",-- straight-flush
    "4h 4s ks 5d 10s",-- one-pair
    "qc 10c 7c 6c 4c" -- flush
}
for _, case in pairs(testCases) do print(case, ": " .. rank(case)) end
