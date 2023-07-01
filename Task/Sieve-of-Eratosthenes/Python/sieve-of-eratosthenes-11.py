import heapq

# generates all prime numbers
def sieve():
    # priority queue of the sequences of non-primes
    # the priority queue allows us to get the "next" non-prime quickly
    nonprimes = []

    i = 2
    while True:
        if nonprimes and i == nonprimes[0][0]: # non-prime
            while nonprimes[0][0] == i:
                # for each sequence that generates this number,
                # have it go to the next number (simply add the prime)
                # and re-position it in the priority queue
                x = nonprimes[0]
                x[0] += x[1]
                heapq.heapreplace(nonprimes, x)

        else: # prime
            # insert a 2-element list into the priority queue:
            # [current multiple, prime]
            # the first element allows sorting by value of current multiple
            # we start with i^2
            heapq.heappush(nonprimes, [i*i, i])
            yield i

        i += 1
