########################
#                      #
#   COPRIME TRIPLETS   #
#                      #
########################

#Starting from the sequence a(1)=1 and a(2)=2 find the next smallest number
#which is coprime to the last two predecessors and has not yet appeared in
#the sequence.
#p and q are coprimes if they have no common factors other than 1.
#Let p, q < 50

#Function to find the Greatest Common Divisor between v1 and v2
def Gcd(v1, v2):
    a, b = v1, v2
    if (a < b):
        a, b = v2, v1
    r = 1
    while (r != 0):
        r = a % b
        if (r != 0):
            a = b
            b = r
    return b

#The first two values
a = [1, 2]
#The next value candidate to belong to a triplet
n = 3

while (n < 50):
    gcd1 = Gcd(n, a[-1])
    gcd2 = Gcd(n, a[-2])

    #if n is coprime of the previous two value and isn't present in the list
    if (gcd1 == 1 and gcd2 == 1 and not(n in a)):
        #n is the next element of a triplet
        a.append(n)
        n = 3
    else:
        #searching a new triplet with the next value
        n += 1

#printing the result
for i in range(0, len(a)):
    if (i % 10 == 0):
        print('')
    print("%4d" % a[i], end = '');


print("\n\nNumber of elements in coprime triplets = " + str(len(a)), end = "\n")
