# v0.6.0

function printlyrics()
    const gifts = split("""
    A partridge in a pear tree.
    Two turtle doves
    Three french hens
    Four calling birds
    Five golden rings
    Six geese a-laying
    Seven swans a-swimming
    Eight maids a-milking
    Nine ladies dancing
    Ten lords a-leaping
    Eleven pipers piping
    Twelve drummers drumming
    """, '\n')
    const days = split("""
    first second third fourth fifth
    sixth seventh eighth ninth tenth
    eleventh twelfth""")
    for (n, day) in enumerate(days)
        g = gifts[n:-1:1]
        print("\nOn the $day day of Christmas\nMy true love gave to me:\n")
        if n == 1
            print(join(g[1:end], '\n'), '\n')
        else
            print(join(g[1:end-1], '\n'), " and\n", g[end], '\n')
        end
    end
end

printlyrics()
