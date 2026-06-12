print("working...")
print("Steady squares under 10.000 are:")
limit = 10000

for n in range(1,limit):
    nstr = str(n)
    nlen = len(nstr)
    square = str(pow(n,2))
    rn = square[-nlen:]
    if nstr == rn:
       print(str(n) + " " + str(square))

print("done...")
