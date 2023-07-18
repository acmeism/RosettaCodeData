# find the first 20 antiprimes
# - numbers woth more divisors than the previous numbers

numberOfDivisorCounts = 0
maxDivisor = 0
num = 0
n = 0
result = list(20)
while num < 20
      n += 1
      if n > numberOfDivisorCounts
         # need a bigger table of divisor counts
         numberOfDivisorCounts += 5000
         ndc = list(numberOfDivisorCounts)
         for i = 1 to numberOfDivisorCounts
             ndc[ i ] = 1
         next
         for i = 2 to numberOfDivisorCounts
             j = i
             while j <= numberOfDivisorCounts
                ndc[ j ] = ndc[ j ] + 1
                j += i
             end
         next
      ok
      div = ndc[ n ]
      if (div > maxDivisor)
         maxDivisor = div
         num += 1
         result[num] = n
      ok
end
see result[1]
for n = 2 to len(result)
    see " " + string(result[n])
next
