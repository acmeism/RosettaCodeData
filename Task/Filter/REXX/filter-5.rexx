/*REXX pgm find all even numbers from an array,  marks ¬ even numbers.  */
parse arg N seed .                     /*get optional parameters from CL*/
if N=='' | N==','          then N=50   /*Not specified? Then use default*/
if seed\=='' & seed\==','  then call random ,,seed  /*for repeatability.*/

               do i=1  for N           /*gen  N  random numbers ──►  OLD*/
               @.i=random(1,99999)     /*randum number  1  ──►  99999   */
               end   /*i*/

      do j=1  for N                    /*process the OLD array elements.*/
      if @.j//2 \==0  then @.j=        /*mark  @  array that it's ¬even.*/
      end   /*j*/

            do k=1  for N              /*display all the @ even numbers.*/
            if @.k==''  then iterate   /*if it's marked ¬even,  skip it.*/
            say  right('array.'k, 20)  "="  right(@.k,9)   /*show a line*/
            end   /*k*/
                                       /*stick a fork in it, we're done.*/
