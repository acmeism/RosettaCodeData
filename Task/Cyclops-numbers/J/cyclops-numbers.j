makecyclops =: 3 : 0
NB. y Number of digits (must be odd, greater than 2)
side =. nums #~ -. '0' +./@:="1 nums =: ":"0 (0.1 * base) }. i. base =. 10 ^ <. -: y
, /:~ ". ,/ (side ,"1 0 '0') ,"1"2 1 side
)

go =: 3 : 0
cyclops =. 0 , ; <@:makecyclops"0 (3 5 7)
('First 50 Cyclops numbers:' , ": 5 10 $ cyclops) (1!:2) 2
((LF , 'First 50 prime Cyclops numbers:') , ": 5 10 $ primes =. cyclops ([ #~ e.) p: i.600000) (1!:2) 2
((LF , 'First 50 blind prime Cyclops numbers:') , ": 5 10 $ (primes #~ (, ". '0' -.~"0 1 ": ,. primes) e. p: i.10000)) (1!:2) 2
(LF , 'First 50 palindromic prime Cyclops numbers:') , ": 5 10 $ primes #~ > (-: |.) &. > <@:":"1 ,. primes
)
