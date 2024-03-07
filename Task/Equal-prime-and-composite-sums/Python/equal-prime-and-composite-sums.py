# equal_prime_comp_sums.py by Xing216
import math
import numpy
def prime_composites(upto=50000):
    nums = numpy.arange(2,upto+1)
    primes=numpy.arange(3,upto+1,2)
    isprime=numpy.ones((upto-1)//2,dtype=bool)
    for factor in primes[:int(math.sqrt(upto))//2]:
        if isprime[(factor-2)//2]: isprime[(factor*3-2)//2::factor]=0
    primes = numpy.insert(primes[isprime],0,2)
    intersect = nums[numpy.in1d(nums, primes)]
    mask1 = numpy.searchsorted(nums,intersect)
    composites = numpy.delete(nums,mask1)
    return primes, composites
primes, composites = prime_composites()
cum_primes = numpy.cumsum(primes)
cum_composites = numpy.cumsum(composites)
print("Sum        | Prime Index | Composite Index")
print("------------------------------------------")
for idx, num in enumerate(cum_primes):
    if num in cum_composites:
        print(f"{num:10,} | {idx+1:11,} | {numpy.where(cum_composites == num)[0][0]+1:15,}")
