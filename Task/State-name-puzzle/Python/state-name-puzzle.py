from collections import defaultdict

states = ["Alabama", "Alaska", "Arizona", "Arkansas",
"California", "Colorado", "Connecticut", "Delaware", "Florida",
"Georgia", "Hawaii", "Idaho", "Illinois", "Indiana", "Iowa", "Kansas",
"Kentucky", "Louisiana", "Maine", "Maryland", "Massachusetts",
"Michigan", "Minnesota", "Mississippi", "Missouri", "Montana",
"Nebraska", "Nevada", "New Hampshire", "New Jersey", "New Mexico",
"New York", "North Carolina", "North Dakota", "Ohio", "Oklahoma",
"Oregon", "Pennsylvania", "Rhode Island", "South Carolina",
"South Dakota", "Tennessee", "Texas", "Utah", "Vermont", "Virginia",
"Washington", "West Virginia", "Wisconsin", "Wyoming",
# Uncomment the next line for the fake states.
# "New Kory", "Wen Kory", "York New", "Kory New", "New Kory"
]

states = sorted(set(states))

smap = defaultdict(list)
for i, s1 in enumerate(states[:-1]):
    for s2 in states[i + 1:]:
        smap["".join(sorted(s1 + s2))].append(s1 + " + " + s2)

for pairs in sorted(smap.itervalues()):
    if len(pairs) > 1:
        print " = ".join(pairs)
