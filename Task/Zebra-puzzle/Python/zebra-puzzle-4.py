from constraint import *

problem = Problem()

Nation = ["Englishman", "Spaniard", "Japanese",     "Ukrainian",   "Norwegian" ]
Color  = ["Red",        "Green",    "White",        "Yellow",      "Blue"      ]
Smoke  = ["Oldgold",    "Kools",    "Chesterfield", "Luckystrike", "Parliament"]
Pet    = ["Dog",        "Snails",   "Fox",          "Horse",       "Zebra"     ]
Drink  = ["Tea",        "Coffee",   "Milk",         "Orangejuice", "Water"     ]

# add variables: house numbers 1 to 5
problem.addVariables(Nation, range(1,5+1))
problem.addVariables(Color,  range(1,5+1))
problem.addVariables(Smoke,  range(1,5+1))
problem.addVariables(Pet,    range(1,5+1))
problem.addVariables(Drink,  range(1,5+1))

# add constraint: the values in each list are exclusive
problem.addConstraint(AllDifferentConstraint(), Nation)
problem.addConstraint(AllDifferentConstraint(), Color)
problem.addConstraint(AllDifferentConstraint(), Smoke)
problem.addConstraint(AllDifferentConstraint(), Pet)
problem.addConstraint(AllDifferentConstraint(), Drink)

# add constraint: actual constraints
problem.addConstraint(lambda a, b: a == b,                   ["Englishman",   "Red"        ])
problem.addConstraint(lambda a, b: a == b,                   ["Spaniard",     "Dog"        ])
problem.addConstraint(lambda a, b: a == b,                   ["Green",        "Coffee"     ])
problem.addConstraint(lambda a, b: a == b,                   ["Ukrainian",    "Tea"        ])
problem.addConstraint(lambda a, b: a == b + 1,               ["Green",        "White"      ])
problem.addConstraint(lambda a, b: a == b,                   ["Oldgold",      "Snails"     ])
problem.addConstraint(lambda a, b: a == b,                   ["Yellow",       "Kools"      ])
problem.addConstraint(lambda a: a == 3,                      ["Milk"                       ])
problem.addConstraint(lambda a: a == 1,                      ["Norwegian"                  ])
problem.addConstraint(lambda a, b: a == b - 1 or a == b + 1, ["Chesterfield", "Fox"        ])
problem.addConstraint(lambda a, b: a == b - 1 or a == b + 1, ["Kools",        "Horse"      ])
problem.addConstraint(lambda a, b: a == b,                   ["Luckystrike",  "Orangejuice"])
problem.addConstraint(lambda a, b: a == b,                   ["Japanese",     "Parliament" ])
problem.addConstraint(lambda a, b: a == b - 1 or a == b + 1, ["Norwegian",    "Blue"       ])

# get solution
sol = problem.getSolution()

# print the answers
nation = ["Nation" if i == 0 else ""  for i in range(6)]
color  = ["Color"  if i == 0 else ""  for i in range(6)]
smoke  = ["Smoke"  if i == 0 else ""  for i in range(6)]
pet    = ["Pet"    if i == 0 else ""  for i in range(6)]
drink  = ["Drink"  if i == 0 else ""  for i in range(6)]
for n in Nation:
    nation[sol[n]] = n
for n in Color:
    color[sol[n]] = n
for n in Smoke:
    smoke[sol[n]] = n
for n in Pet:
    pet[sol[n]] = n
for n in Drink:
    drink[sol[n]] = n
for d in [nation, color, smoke, pet, drink]:
    print("%6s: %14s%14s%14s%14s%14s" % (d[0], d[1], d[2], d[3], d[4], d[5]))
