(de prime? (N Lst)
   (let S (sqrt N)
      (for D Lst
         (T (> D S) T)
         (T (=0 (% N D)) NIL) ) ) )

(de take (N)
   (let I 1
      (make
         (link 2)
         (do (dec N)
            (until (prime? (inc 'I 2) (made)))
            (link I) ) ) ) )

# This is a simple approach to calculate primorial may not be the fastest one
(de primorial (N)
   (apply * (take N)) )

#print 1st 10 primorial numbers
(for M 10 (prinl "primorial: "(primorial M)))

# print the length of primorial numbers.
[prinl (length (primorial (** 10 1)]
[prinl (length (primorial (** 10 2)]
[prinl (length (primorial (** 10 3)]
[prinl (length (primorial (** 10 4)]
#The last one takes a very long time to compute.
[prinl (length (primorial (** 10 5)]
