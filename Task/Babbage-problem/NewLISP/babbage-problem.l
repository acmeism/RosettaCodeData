;;;	Start by assigning n the integer square root of 269696
;;;	minus 1 to be even
(setq n 518)
;;;	Increment n by 2 till the last 6 digits of its square are 269696
(while (!= (% (* n n) 1000000) 269696)
	(++ n 2))
;;;	Show the result and its square
(println n "^2 = " (* n n))
