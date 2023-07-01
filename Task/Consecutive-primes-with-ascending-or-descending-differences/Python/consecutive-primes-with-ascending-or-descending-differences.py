from sympy import sieve

primelist = list(sieve.primerange(2,1000000))

listlen = len(primelist)

# ascending

pindex = 1
old_diff = -1
curr_list=[primelist[0]]
longest_list=[]

while pindex < listlen:

    diff = primelist[pindex] - primelist[pindex-1]
    if diff > old_diff:
        curr_list.append(primelist[pindex])
        if len(curr_list) > len(longest_list):
            longest_list = curr_list
    else:
        curr_list = [primelist[pindex-1],primelist[pindex]]

    old_diff = diff
    pindex += 1

print(longest_list)

# descending

pindex = 1
old_diff = -1
curr_list=[primelist[0]]
longest_list=[]

while pindex < listlen:

    diff = primelist[pindex] - primelist[pindex-1]
    if diff < old_diff:
        curr_list.append(primelist[pindex])
        if len(curr_list) > len(longest_list):
            longest_list = curr_list
    else:
        curr_list = [primelist[pindex-1],primelist[pindex]]

    old_diff = diff
    pindex += 1

print(longest_list)
