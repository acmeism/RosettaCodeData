yinyang  = ["yang", "yin"]
elements = ["Wood", "Fire", "Earth", "Metal", "Water"]
animals  = ["Rat", "Ox", "Tiger", "Rabbit", "Dragon", "Snake",
            "Horse", "Goat", "Monkey", "Rooster", "Dog", "Pig"]
years    = [1801, 1861, 1984, 2020, 2186, 76543]
output   = ""

for year in years
    yy      = year % 2 + 1
    element = (year - 4) % 5 + 1
    animal  = (year - 4) % 12 + 1
    output  = string(year) + " is the year of the "
    output += elements[element] + " " + animals[animal] + " (" + yinyang[yy] + ")."
    ? output
next
