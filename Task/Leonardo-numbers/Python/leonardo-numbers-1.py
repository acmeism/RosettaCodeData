def Leonardo(L_Zero, L_One, Add, Amount):
    terms = [L_Zero,L_One]
    while len(terms) < Amount:
        new = terms[-1] + terms[-2]
        new += Add
        terms.append(new)
    return terms

out = ""
print "First 25 Leonardo numbers:"
for term in Leonardo(1,1,1,25):
    out += str(term) + " "
print out

out = ""
print "Leonardo numbers with fibonacci parameters:"
for term in Leonardo(0,1,0,25):
    out += str(term) + " "
print out
