load 'format/printf'

NB. I don't know of any way to easily make an idiomatic lazy exploration,
NB. except falling back on explicit imperative control strutures.
NB. However this is clearly not where J shines neither with speed nor elegance.

primes_up_to  =: monad def 'p: i. _1 p: 1 + y'
terms_as_text =: monad def '; }: , (": each y),.<'' + '''

search_next_terms =: dyad define
 acc=. x     NB. -> an accumulator that contains given beginning of the partition.
 p=.   >0{y  NB. -> number of elements wanted in the partition
 ns=.  >1{y  NB. -> candidate values to be included in the partition
 sum=. >2{y  NB. -> the integer to partition

 if. p=0 do.
    if. sum=+/acc do. acc return. end.
 else.
   for_m. i. (#ns)-(p-1) do.
     r =. (acc,m{ns) search_next_terms (p-1);((m+1)}.ns);sum
     if. #r do. r return. end.
   end.
 end.

 0$0   NB. Empty result if nothing found at the end of this path.
)


NB. Prints  a partition of y primes whose sum equals x.
partitioned_in =: dyad define
    terms =. (0$0) search_next_terms y;(primes_up_to x);x
    if. #terms do.
       'As the sum of %d primes, %d = %s' printf y;x; terms_as_text terms
    else.
       'Didn''t find a way to express %d as a sum of %d different primes.' printf x;y
    end.
)


tests=: (99809 1) ; (18 2) ; (19 3) ; (20 4) ; (2017 24) ; (22699 1) ; (22699 2) ; (22699 3) ; (22699 4)
(0&{ partitioned_in 1&{) each tests
