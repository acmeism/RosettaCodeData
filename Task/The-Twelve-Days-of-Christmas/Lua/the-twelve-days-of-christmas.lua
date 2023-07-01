local days = {
    'first', 'second', 'third', 'fourth', 'fifth', 'sixth', 'seventh', 'eighth', 'ninth',
    'tenth', 'eleventh', 'twelfth',
}

local gifts = {
    "A partridge in a pear tree",
    "Two turtle doves",
    "Three french hens",
    "Four calling birds",
    "Five golden rings",
    "Six geese a-laying",
    "Seven swans a-swimming",
    "Eight maids a-milking",
    "Nine ladies dancing",
    "Ten lords a-leaping",
    "Eleven pipers piping",
    "Twelve drummers drumming",
}

local verses = {}

for i = 1, 12 do
    local lines = {}
    lines[1] = "On the " .. days[i] .. " day of Christmas, my true love gave to me"

    local j = i
    local k = 2
    repeat
        lines[k] = gifts[j]
        k = k + 1
        j = j - 1
    until j == 0

    verses[i] = table.concat(lines, '\n')
end

print(table.concat(verses, '\n\n'))
