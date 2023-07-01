"""

Python implementation of

http://rosettacode.org/wiki/Increasing_gaps_between_consecutive_Niven_numbers

"""

# based on C example

# Returns the sum of the digits of n given the
# sum of the digits of n - 1
def digit_sum(n, sum):
    sum += 1
    while n > 0 and n % 10 == 0:
        sum -= 9
        n /= 10

    return sum

previous = 1
gap = 0
sum = 0
niven_index = 0
gap_index = 1

print("Gap index  Gap    Niven index    Niven number")

niven = 1

while gap_index <= 22:
    sum = digit_sum(niven, sum)
    if niven % sum == 0:
        if niven > previous + gap:
            gap = niven - previous;
            print('{0:9d} {1:4d}  {2:13d}     {3:11d}'.format(gap_index, gap, niven_index, previous))
            gap_index += 1
        previous = niven
        niven_index += 1
    niven += 1
