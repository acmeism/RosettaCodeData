( First we set out the steps the computer will use to solve the problem )

: BABBAGE
    1 ( start from the number 1 )
    BEGIN ( commence a "loop": the computer will return to this point repeatedly )
        1+ ( add 1 to our number )
        DUP DUP ( duplicate the result twice, so we now have three copies )
        ( We need three because we are about to multiply two of them together to find the square, and the third will be used the next time we go around the loop -- unless we have found our answer, in which case we shall need to print it out )
        * ( * means "multiply", so we now have the square )
        1000000 MOD ( find the remainder after dividing it by a million )
        269696 = ( is it equal to 269,696? )
    UNTIL ( keep repeating the steps from BEGIN until the condition is satisfied )
    . ; ( when it is satisfied, print out the number that allowed us to satisfy it )

( Now we ask the machine to carry out these instructions )

BABBAGE
