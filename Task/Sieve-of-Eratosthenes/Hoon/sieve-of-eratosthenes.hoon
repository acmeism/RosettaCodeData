::  Find primes by the sieve of Eratosthenes
!:
|=  end=@ud
=/  index  2
=/  primes  `(list @ud)`(gulf 1 end)
|-  ^-  (list @ud)
?:  (gte index (lent primes))  primes
$(index +(index), primes +:(skid primes |=([a=@ud] &((gth a index) =(0 (mod a index))))))
