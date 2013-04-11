Set a = ['John', 'Serena', 'Bob', 'Mary', 'Serena']
Set b = ['Jim', 'Mary', 'John', 'Jim', 'Bob']

assert a.size() == 4
assert a == (['Bob', 'John', 'Mary', 'Serena'] as Set)
assert b.size() == 4
assert b == (['Bob', 'Jim', 'John', 'Mary'] as Set)

def aa = symDiff(a, a)
def ab = symDiff(a, b)
def ba = symDiff(b, a)
def bb = symDiff(b, b)

assert aa.empty
assert bb.empty
assert ab == ba
assert ab == (['Jim', 'Serena'] as Set)
assert ab == (['Serena', 'Jim'] as Set)

println """
a: ${a}
b: ${b}

Symmetric Differences
=====================
a <> a: ${aa}
a <> b: ${ab}
b <> a: ${ba}
b <> b: ${bb}


"""

Set apostles = ['Matthew', 'Mark', 'Luke', 'John', 'Peter', 'Paul', 'Silas']
Set beatles = ['John', 'Paul', 'George', 'Ringo', 'Peter', 'Stuart']
Set csny = ['Crosby', 'Stills', 'Nash', 'Young']
Set ppm = ['Peter', 'Paul', 'Mary']

def AA = symDiff(apostles, apostles)
def AB = symDiff(apostles, beatles)
def AC = symDiff(apostles, csny)
def AP = symDiff(apostles, ppm)

def BA = symDiff(beatles, apostles)
def BB = symDiff(beatles, beatles)
def BC = symDiff(beatles, csny)
def BP = symDiff(beatles, ppm)

def CA = symDiff(csny, apostles)
def CB = symDiff(csny, beatles)
def CC = symDiff(csny, csny)
def CP = symDiff(csny, ppm)

def PA = symDiff(ppm, apostles)
def PB = symDiff(ppm, beatles)
def PC = symDiff(ppm, csny)
def PP = symDiff(ppm, ppm)

assert AB == BA
assert AC == CA
assert AP == PA
assert BC == CB
assert BP == PB
assert CP == PC

println """
apostles: ${apostles}
 beatles: ${beatles}
    csny: ${csny}
     ppm: ${ppm}

Symmetric Differences
=====================
apostles <> apostles: ${AA}
apostles <> beatles:  ${AB}
apostles <> csny:     ${AC}
apostles <> ppm:      ${AP}

beatles <> apostles:  ${BA}
beatles <> beatles:   ${BB}
beatles <> csny:      ${BC}
beatles <> ppm:       ${BP}

csny <> apostles:     ${CA}
csny <> beatles:      ${CB}
csny <> csny:         ${CC}
csny <> ppm:          ${CP}

ppm <> apostles:      ${PA}
ppm <> beatles:       ${PB}
ppm <> csny:          ${PC}
ppm <> ppm:           ${PP}
"""
