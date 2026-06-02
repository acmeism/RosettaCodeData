Rebol [
    title: "Rosetta code: Sort stability"
    file:  %Sort_stability.r3
    url:   https://rosettacode.org/wiki/Sort_stability
    needs: 3.21.7
]

data: [
    UK  "London"
    US  "New York"
    US  "Birmingham"
    UK  "Birmingham"
]

print "Original data:"
probe data
print "--------------------------"
print "Stable sorted on column 2:"
probe sort/skip/compare data 2 2
print "Stable sorted on column 1:"
probe sort/skip data 2
print "--------------------------"

data: [
    UK  "London"
    US  "New York"
    US  "Birmingham"
    UK  "Birmingham"
]

print "Unstable sorted on column 2:"
probe sort/skip/compare/unstable data 2 2
print "Unstable sorted on column 1:"
probe sort/skip/unstable data 2
