"""
Jokes about courtesans aside, the selection process is by the letters of the names.
If the integer corresponding to the ASCII character of the first letter of the
name is even, the woman is considered nice. If the integers of the last letter of
the lady's name and the sailor's name are both odd or both even, the sailor should
consider the lady as lovable.
"""

sailors = ['Adrian', 'Caspian', 'Dune', 'Finn', 'Fisher', 'Heron', 'Kai',
           'Ray', 'Sailor', 'Tao']

ladies = ['Ariel', 'Bertha', 'Blue', 'Cali', 'Catalina', 'Gale', 'Hannah',
           'Isla', 'Marina', 'Shelly']

def isnicegirl(s):
    return ord(s[0]) % 2 == 0

def islovable(slady, ssailor):
    return ord(slady[-1]) % 2 == ord(ssailor[-1]) % 2

for lady in ladies:
    if isnicegirl(lady):
        print("Dating service should offer a date with", lady)
        for sailor in sailors:
            if islovable(lady, sailor):
                print("    Sailor", sailor, "should take an offer to date her.")
    else:
        print("Dating service should NOT offer a date with", lady)
