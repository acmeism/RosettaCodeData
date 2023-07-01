NB. This would have been shorter but memory constraints forced me to test candidates
NB. in batches rather than all at once (iPads are amazing but not supercomputers...)

gennumberblocks =: 3 : 0
NB. y Block index.  Each block is at most 100000 numbers
NB. Return one or more boxed blocks of numbers, segregated by digit count
(<. 10 ^. n) </. n =. (y * 100000) + >: i.100000
)

testblock =: 3 : 0
NB. y A block of numbers all with the same digit count
NB. Return those that pass the test
y #~ ((+/"1) 2 </\"1 f) = (+/"1) 2 >/\"1 "."1"0 ": ,. y
)

pow =: 3 : 0
NB. Generate and test one or more blocks of numbers and add the results to the
NB. running list of answers
'nextblockindex answers' =. y
(>: nextblockindex) ; answers , ; testblock &. > gennumberblocks nextblockindex
)

go =: 3 : 0
result =: pow ^: ((1e7&>)@#@(1&{::)) ^:_ (0 ; '')
'The first 200 numbers are:' (1!:2) 2
(10 20 $ 200 {. 1 {:: result) (1!:2) 2
'The 10,000,000th number is: ' , ": 9999999 { 1 {:: result
)
