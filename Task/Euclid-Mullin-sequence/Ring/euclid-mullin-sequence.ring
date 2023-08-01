// find elements of the Euclid-Mullin sequence: starting from 2,
// the next element is the smallest prime factor of 1 + the product
// of the previous elements
see "2"
product = 2
for i = 2 to 8
    nextV = product + 1
    // find the first prime factor of nextV
    p = 3
    found = false
    while p * p <= nextV and not found
        found = ( nextV % p ) = 0
        if not found p = p + 2 ok
    end
    if found nextV = p ok
    see " " + nextV
    product = product * nextV
next
