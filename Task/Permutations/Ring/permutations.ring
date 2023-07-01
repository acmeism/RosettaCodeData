Another Solution

// Permutations -- Bert Mariani  2020-07-12
// Ask User for number of digits to permutate

   ? "Enter permutations number : "  Give n
   n = number(n)
   x = 1:n                            // array

    ? "Permutations are : "
   count = 0

    nPermutation(1,n)                  //===>>>  START

    ? " "                              // ? = print
    ? "Exiting of the program... "
    ? "Enter to Exit : "  Give m       // To Exit CMD window

//======================
// Returns true only if uniq number on row

Func Place(k,i)

     for j=1 to k-1
          if x[j] = i                  // Two numbers in same row
             return 0
          ok
     next

return 1

//======================
Func nPermutation(k, n)

     for i = 1 to n
          if( Place(k,i))              //===>>> Call
               x[k] = i
               if(k=n)
                  See nl
                     for i= 1 to n
                  See " "+ x[i]
                     next
                  See "    "+ (count++)
               else
                    nPermutation(k+1,n)   //===>>>  Call RECURSION
               ok
          ok
     next
return
