--REXX program to show arbitrary precision integers.
numeric digits 200000
check = '62060698786608744707...92256259918212890625'

start = .datetime~new
n = 5 ** (4 ** (3**2))
time = .datetime~new - start
say 'elapsed time for the calculation:' time
say
sampl = left(n, 20)"..."right(n, 20)

say ' check:' check
say 'Sample:' sampl
say 'digits:' length(n)
say

if check=sampl then say 'passed!'
               else say 'failed!'
