"""

http://rosettacode.org/wiki/Factorial_base_numbers_indexing_permutations_of_a_collection

https://en.wikipedia.org/wiki/Factorial_number_system

"""

import math

def apply_perm(omega,fbn):
    """

    omega contains a list which will be permuted (scrambled)
    based on fbm.

    fbm is a list which represents a factorial base number.

    This function just translates the pseudo code in the
    Rosetta Code task.

    """
    for m in range(len(fbn)):
        g = fbn[m]
        if g > 0:
            # do rotation
            # save last number
            new_first = omega[m+g]
            # move numbers right
            omega[m+1:m+g+1] = omega[m:m+g]
            # put last number first
            omega[m] = new_first

    return omega

def int_to_fbn(i):
    """

    convert integer i to factorial based number

    """
    current = i
    divisor = 2
    new_fbn = []
    while current > 0:
        remainder = current % divisor
        current = current // divisor
        new_fbn.append(remainder)
        divisor += 1

    return list(reversed(new_fbn))

def leading_zeros(l,n):
   """

   If list l has less than n elements returns l with enough 0 elements
   in front of the list to make it length n.

   """
   if len(l) < n:
       return(([0] * (n - len(l))) + l)
   else:
       return l

def get_fbn(n):
    """

    Return the n! + 1 first Factorial Based Numbers starting with zero.

    """
    max = math.factorial(n)

    for i in range(max):
        # from Wikipedia article
        current = i
        divisor = 1
        new_fbn = int_to_fbn(i)
        yield leading_zeros(new_fbn,n-1)

def print_write(f, line):
    """

    prints to console and
    output file f

    """
    print(line)
    f.write(str(line)+'\n')

def dot_format(l):
    """
    Take a list l that is a factorial based number
    and returns it in dot format.

    i.e. [0, 2, 1] becomes 0.2.1
    """
    # empty list
    if len(l) < 1:
        return ""
    # start with just first element no dot
    dot_string = str(l[0])
    # add rest if any with dots
    for e in l[1:]:
        dot_string += "."+str(e)

    return dot_string

def str_format(l):
    """
    Take a list l and returns a string
    of those elements converted to strings.
    """
    if len(l) < 1:
        return ""

    new_string = ""

    for e in l:
        new_string += str(e)

    return new_string

with open("output.html", "w", encoding="utf-8") as f:
    f.write("<pre>\n")

    # first print list

    omega=[0,1,2,3]

    four_list = get_fbn(4)

    for l in four_list:
        print_write(f,dot_format(l)+' -> '+str_format(apply_perm(omega[:],l)))

    print_write(f," ")

    # now generate this output:
    #
    # Permutations generated = 39916800
    # compared to 11! which  = 39916800


    num_permutations = 0

    for p in get_fbn(11):
        num_permutations += 1
        if num_permutations % 1000000 == 0:
            print_write(f,"permutations so far = "+str(num_permutations))

    print_write(f," ")
    print_write(f,"Permutations generated = "+str(num_permutations))
    print_write(f,"compared to 11! which  = "+str(math.factorial(11)))

    print_write(f," ")



    """

    u"\u2660" - spade

    u"\u2665" - heart

    u"\u2666" - diamond

    u"\u2663" - club

    """

    shoe = []

    for suit in [u"\u2660",u"\u2665",u"\u2666",u"\u2663"]:
        for value in ['A','K','Q','J','10','9','8','7','6','5','4','3','2']:
            shoe.append(value+suit)

    print_write(f,str_format(shoe))

    p1 = [39,49,7,47,29,30,2,12,10,3,29,37,33,17,12,31,29,34,17,25,2,4,25,4,1,14,20,6,21,18,1,1,1,4,0,5,15,12,4,3,10,10,9,1,6,5,5,3,0,0,0]

    p2 = [51,48,16,22,3,0,19,34,29,1,36,30,12,32,12,29,30,26,14,21,8,12,1,3,10,4,7,17,6,21,8,12,15,15,13,15,7,3,12,11,9,5,5,6,6,3,4,0,3,2,1]

    print_write(f," ")
    print_write(f,dot_format(p1))
    print_write(f," ")
    print_write(f,str_format(apply_perm(shoe[:],p1)))

    print_write(f," ")
    print_write(f,dot_format(p2))
    print_write(f," ")
    print_write(f,str_format(apply_perm(shoe[:],p2)))

    # generate random 51 digit factorial based number

    import random

    max = math.factorial(52)

    random_int = random.randint(0, max-1)

    myperm = leading_zeros(int_to_fbn(random_int),51)

    print(len(myperm))

    print_write(f," ")
    print_write(f,dot_format(myperm))
    print_write(f," ")
    print_write(f,str_format(apply_perm(shoe[:],myperm)))

    f.write("</pre>\n")
