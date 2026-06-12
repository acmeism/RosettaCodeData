// Bert Mariani  2023-02-09 | A Monte Carlo method to solve the encryted message | SEND + MORE = MONEY

t1 = clock()          //
See "Start Clock: "+ t1 +nl
counter    = 1
aSendory   = [["s","-"],["e","-"],["n","-"],["d","-"],["o","-"],["r","-"],["y","-"]]
aRandom    = List(10)                       // 0-9

for j = 1 to 100000000
	aRandom = GenRandomUniq()            // 5 2 0 8 7 1 6 4 3 9 	
	for i = 1 to 7
	    if aRandom[1] != 1               // m = 1
	       aSendory[i][2] = aRandom[1]
	       del(aRandom,1)                // Shorten list, remove value entry picked
	    else
	       del(aRandom,1)
	       i--
	    ok
	next
        if (TrySolution(aSendory)) break  else  counter++   ok  // True=1 = Solution Found
next
See "End   Clock.: "+ (clock() - t1) +nl
See "Count cycles: "+ counter +nl

Func GenRandomUniq()
throwLimit = 10                      // 0-9, Ring does 1-10
aList = 1:throwLimit
aOut  = []
while len(aOut) != throwLimit
    nSize = len(aList)	
    if nSize > 0
        nIndex = random(nSize)       // Random pointer into list
        if nIndex = 0  nIndex=1 ok   // Ignore 0, Ring Index at 1-10		
        aOut + (aList[nIndex] -1)    // -1 fix value 0-9, Ring +1 Extract list entry content
        del(aList,nIndex)            // Shorten list, remove value entry picked
    else
        aOut + aList[1]
        aList = []
    ok
end
return aOut

Func TrySolution(aTry)
     s1 = ( aTry[1][2]) * 1000      // send
     e1 = ( aTry[2][2]) *  100
     n1 = ( aTry[3][2]) *   10
     d1 = ( aTry[4][2]) *    1
     nbr1 = s1 + e1 + n1 + d1
     m1 = 1             * 1000      // more
     o1 = ( aTry[5][2]) *  100
     r1 = ( aTry[6][2]) *   10
     e1 = ( aTry[2][2]) *    1
     nbr2 = m1 + o1 + r1 + e1
     m1 = 1             * 10000     // money
     o1 = ( aTry[5][2]) *  1000
     n1 = ( aTry[3][2]) *   100
     e1 = ( aTry[2][2]) *    10
     y1 = ( aTry[7][2]) *     1
     nbr3 = m1 + o1 +n1 + e1 + y1
     nbr4 = nbr1 + nbr2
     if (nbr3 = nbr4)
        See "Solved: SEND: "+ nbr1 +" MORE: "+ nbr2 +" MONEY: "+ nbr3 +" Check "+ nbr4 +nl
        return (nbr3 = nbr4 )      // True
     ok
return False

