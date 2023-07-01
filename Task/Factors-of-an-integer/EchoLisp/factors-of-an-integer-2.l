(lib 'bigint)
(factors 666)
   → (1 2 3 6 9 18 37 74 111 222 333 666)

(length (factors 108233175859200))
   → 666 ;; 💀

(define huge 1200034005600070000008900000000000000000)
(time ( length (factors huge)))
    → (394ms 7776)
