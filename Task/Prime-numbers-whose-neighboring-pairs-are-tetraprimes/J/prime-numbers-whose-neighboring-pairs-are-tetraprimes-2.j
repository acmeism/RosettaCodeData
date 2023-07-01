   NB. (1) primes less than 1e5 preceeded by two tetraprimes
   {{y#~*/tetrap 1 2-~/y}} primeslt 1e5
8647 15107 20407 20771 21491 23003 23531 24767 24971 27967 29147 33287 34847 36779 42187 42407 42667 43331 43991 46807 46867 51431 52691 52747 53891 54167 58567 63247 63367 69379 71711 73607 73867 74167 76507 76631 76847 80447 83591 84247 86243 87187 87803...
   NB. (2) primes less than 1e5 followed by two tetraprimes
   {{y#~*/tetrap 1 2+/y}} primeslt 1e5
8293 16553 17389 18289 22153 26893 29209 33409 35509 36293 39233 39829 40493 41809 45589 48109 58393 59629 59753 59981 60493 60913 64013 64921 65713 66169 69221 71329 74093 75577 75853 77689 77933 79393 79609 82913 84533 85853 87589 87701 88681 91153 93889...
   NB. (3a) how many primes from (1) have 7 in a factor of a number in the preceeding pair?
   +/0+./ .=7|1 2-~/{{y#~*/tetrap 1 2-~/y}} primeslt 1e5
31
   NB. (3b) how many primes from (2) have 7 in a factor of a number in the following pair?
   +/0+./ .=7|1 2+/{{y#~*/tetrap 1 2+/y}} primeslt 1e5
36
   NB. (4a) minimum, maximum gap between primes in (1)
   (<./,>./)2 -~/\{{y#~*/tetrap 1 2-~/y}} primeslt 1e5
56 6460
   NB. (4b) minimum, maximum gap between primes in (2)
   (<./,>./)2 -~/\{{y#~*/tetrap 1 2+/y}} primeslt 1e5
112 10284
   NB. number of type (1) primes but for primes less than 1e6
   #{{y#~*/tetrap 1 2-~/y}} primeslt 1e6
885
   NB. number of type (2) primes but for primes less than 1e6
   #{{y#~*/tetrap 1 2+/y}} primeslt 1e5
46
   NB. count of type (3a) for primes less than 1e6
   +/0+./ .=7|1 2-~/{{y#~*/tetrap 1 2-~/y}} primeslt 1e6
503
   NB. count of type (3b) for primes less than 1e6
   +/0+./ .=7|1 2+/{{y#~*/tetrap 1 2+/y}} primeslt 1e6
492
   NB. gaps of type (4a) for primes less than 1e6
   (<./,>./)2 -~/\{{y#~*/tetrap 1 2-~/y}} primeslt 1e6
4 7712
   NB. gaps of type (4b) for primes less than 1e6
   (<./,>./)2 -~/\{{y#~*/tetrap 1 2+/y}} primeslt 1e6
4 10284
