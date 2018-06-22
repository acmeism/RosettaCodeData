#if niven number, return it.
(de niven (N)
   (if (=0 (% N (apply+ (getN N)))) N) )

#function which creates a list of numbers from input
(de getN (N)
   (mapcar any (chop N)) )

#function to apply '+' func to list of numbers
(de apply+ (Ln)
   (apply + Ln) )

#function to delete NIL from the entire list
(de delNIL (L)
   (delete NIL L T) )

#This function generates niven number list
(de nivGen (R N)
   (delNIL (mapcar niven (range R N))) )

#print 1st 20 niven numbers and 1st niven number greater than 1000
(printsp ~(list ~(head 20
                    (nivGen 1 1000) ) ~(head 1 (nivGen 1001 1010)) ) )
