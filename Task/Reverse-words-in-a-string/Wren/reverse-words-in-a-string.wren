var  lines = [
    "---------- Ice and Fire ------------",
    "                                    ",
    "fire, in end will world the say Some",
    "ice. in say Some                    ",
    "desire of tasted I've what From     ",
    "fire. favor who those with hold I   ",
    "                                    ",
    "... elided paragraph last ...       ",
    "                                    ",
    "Frost Robert -----------------------"
]

for (line in lines) {
    var tokens = line.trim().split(" ")
    tokens = tokens[-1..0]
    System.print(tokens.join(" "))
}
