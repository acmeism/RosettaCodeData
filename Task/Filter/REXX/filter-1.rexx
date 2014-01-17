/*REXX program selects all even numbers from an array  ──►  a new array.*/
parse arg N seed .                     /*get optional parameters from CL*/
if N=='' | N==','          then N=50   /*Not specified? Then use default*/
if seed\=='' & seed\==','  then call random ,,seed  /*for repeatability.*/
old.=                                  /*the OLD array, all null so far.*/
new.=                                  /*the NEW array, all null so far.*/
               do i=1  for N           /*gen  N  random numbers ──►  OLD*/
               old.i=random(1,99999)   /*randum number  1  ──►  99999   */
               end   /*i*/
#=0                                    /*numb. of elements in NEW so far*/
      do j=1  for N                    /*process the OLD array elements.*/
      if old.j//2 \== 0  then iterate  /*if element isn't even, skip it.*/
      #=#+1                            /*bump the number of NEW elements*/
      new.#=old.j                      /*assign it to the NEW array.    */
      end   /*j*/

            do k=1  for #              /*display all the NEW  numbers.  */
            say  right('new.'k, 20)  "="  right(new.k,9)   /*show a line*/
            end   /*k*/
                                       /*stick a fork in it, we're done.*/
