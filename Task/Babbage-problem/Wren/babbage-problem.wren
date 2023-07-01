/*
    The answer must be an even number and it can't be less than the square root of 269,696.
    So, if we start from that, keep on adding 2 and squaring it we'll eventually find the answer.
    However, we can skip numbers which don't end in 4 or 6 as their squares can't end in 6.
*/

import "/fmt" for Fmt                // this enables us to format numbers with thousand separators
var start = 269696.sqrt.ceil         // get the next integer higher than (or equal to) the square root
start = (start/2).ceil * 2           // if it's odd, use the next even integer
var i = start                        // assign it to a variable 'i' for use in the following loop
while (true) {                       // loop indefinitely till we find the answer
    var sq = i * i                   // get the square of 'i'
    var last6 = sq % 1000000         // get its last 6 digits by taking the remainder after division by a million
    if (last6 == 269696) {           // if those digits are 269696, we're done and can print the result
        Fmt.print("The lowest number whose square ends in 269,696 is $,d.", i)
        Fmt.print("Its square is $,d.", sq)
        break                        // break from the loop and end the program
    }
    if (i % 10 == 6) {               // get the last digit by taking the remainder after division by 10
        i = i + 8                    // if the last digit is 6 add 8 (to end in 4)
    } else {
        i = i + 2                    // otherwise add 2
    }
}
