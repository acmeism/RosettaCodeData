#define UPPER 1000000
#include"isprime.bas"

dim as uinteger champ = 0, record = 0, streak, i, j, n

'first generate all the primes below UPPER
redim as uinteger prime(1 to 2)
prime(1) = 2 : prime(2) = 3
for i = 5 to UPPER step 2
    if isprime(i) then
        redim preserve prime(1 to ubound(prime) + 1)
        prime(ubound(prime)) = i
    end if
next i
n = ubound(prime)

'now look for the longest streak of ascending primes
for i = 2 to n-1
    j = i + 1
    streak = 1
    while j<=n andalso prime(j)-prime(j-1) > prime(j-1)-prime(j-2)
        streak += 1
        j+=1
    wend
    if streak > record then
        champ = i-1
        record = streak
    end if
next i

print "The longest sequence of ascending primes (with their difference from the last one) is:"
for i = champ+1 to champ+record
    print prime(i-1);" (";prime(i)-prime(i-1);") ";
next i
print prime(i-1) : print
'now for the descending ones

record = 0 : champ = 0
for i = 2 to n-1
    j = i + 1
    streak = 1
    while j<=n andalso prime(j)-prime(j-1) < prime(j-1)-prime(j-2)   'identical to above, but for the inequality sign
        streak += 1
        j+=1
    wend
    if streak > record then
        champ = i-1
        record = streak
    end if
next i

print "The longest sequence of descending primes (with their difference from the last one) is:"
for i = champ+1 to champ+record
    print prime(i-1);" (";prime(i)-prime(i-1);") ";
next i
print prime(i-1)
