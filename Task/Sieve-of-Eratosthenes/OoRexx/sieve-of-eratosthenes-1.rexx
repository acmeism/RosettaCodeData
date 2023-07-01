/*ooRexx program generates & displays primes via the sieve of Eratosthenes.
*                       derived from first Rexx version
*                       uses an array rather than a stem for the list
*                       uses string methods rather than BIFs
*                       uses new ooRexx keyword LOOP, extended assignment
*                         and line comments
*                       uses meaningful variable names and restructures code
*                         layout for improved understandability
****************************************************************************/
  arg highest                       --get highest number to use.
  if \highest~datatype('W') then
    highest = 200                   --use default value.
  isPrime = .array~new(highest)     --container for all numbers.
  isPrime~fill(1)                   --assume all numbers are prime.
  w = highest~length                --width of the biggest number,
                                    --  it's used for aligned output.
  out1 = 'prime'~right(20)          --first part of output messages.
  np = 0                            --no primes so far.
  loop j = 2 for highest - 1        --all numbers up through highest.
    if isPrime[j] = 1 then do       --found one.
      np += 1                       --bump the prime counter.
      say out1 np~right(w) ' --> ' j~right(w)   --display output.
      loop m = j * j to highest by j
        isPrime[m] = ''             --strike all multiples: not prime.
      end
    end
  end
  say
  say np~right(out1~length + 1 + w) 'primes found up to and including ' highest
  exit
