# Project : Box the compass

names = ["North", "North by east", "North-northeast",
               "Northeast by north", "Northeast", "Northeast by east", "East-northeast",
               "East by north", "East", "East by south", "East-southeast",
               "Southeast by east", "Southeast", "Southeast by south", "South-southeast",
               "South by east", "South", "South by west", "South-southwest",
               "Southwest by south", "Southwest", "Southwest by west", "West-southwest",
               "West by south", "West", "West by north", "West-northwest",
               "Northwest by west", "Northwest", "Northwest by north", "North-northwest",
               "North by west", "North"]

degrees = [0, 16.87, 16.88, 33.75, 50.62, 50.63,
                67.5, 84.37, 84.38, 101.25, 118.12, 118.13, 135, 151.87, 151.88, 168.75,
                185.62, 185.63, 202.5, 219.37, 219.38, 236.25, 253.12, 253.13, 270,
                286.87, 286.88, 303.75, 320.62, 320.63, 337.5, 354.37, 354.38]

for i = 1 to len(degrees)
     j = floor((degrees[i] + 5.625) / 11.25)
    if j > 31
       j = j - 32
    ok
    see "" + degrees[i] + " " + j + " "
    if j != 0
       see "" + names[j+1] + nl
    else
       see "" + names[len(names)] + nl
    ok
next
