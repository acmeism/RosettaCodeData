/*REXX program implements a sleep sort (with numbers entered from C.L.).*/
numeric digits 300                     /*over the top, but what the hey!*/
                                       /*  (above)  ··· from vaudeville.*/
#.=                                    /*placeholder for the array of #s*/
stuff= 1e9 50 5 40 4 1 100 30 3 12 2 8 9 7 6 6 10 20 0  /*alphabetically*/
parse arg numbers                      /*let the user specify on the CL.*/
if numbers=''  then numbers=stuff      /*Not specified? Then use default*/
N=words(numbers)                       /*N  is the  number  of numbers. */
w=length(N)                            /*width of  N  (for nice output).*/
say N 'numbers to be sorted:' numbers  /*informative informational info.*/

    do j=1  for N                      /*let's start to boogie-woogie.  */
    #.j=word(numbers,j)                /*plug in one number at a time.  */
    if datatype(#.j,'N')  then #.j=#.j/1     /*normalize it if a number.*/
    call fork                          /*only REGINA REXX supports FORK.*/
    call sortItem j                    /*start a sort for array number. */
    end   /*j*/

      do forever  while \inOrder(N)    /*wait for the sorts to complete.*/
      call sleep 1                     /*1 sec is minimum effective time*/
      end    /*forever while*/         /*well, other than zero seconds. */

m=max(length(#.1),length(#.N))         /*width of smallest | largest num*/
say;  say  'after sort:'               /*display blank line and a title.*/

      do k=1  for N                    /*list (sorted) array's elements.*/
      say left('',20)  'array element'  right(k,w)   '───►'   right(#.k,m)
      end   /*k*/
exit                                   /*stick a fork in it, we're done.*/
/*───────────────────────────────────SortItem subroutine────────────────*/
sortItem: procedure expose #.;   parse arg ?        /*sorts single item.*/
              do Asort=1  until \switched           /*cook until cooked.*/
              switched=0                            /*hunky-dorey so far*/
                            do i=1   while   #.i\==''  &  \switched
                            if #.? >= #.i then iterate     /*this one ok*/
                            parse value   #.?  #.i     with     #.i  #.?
                            switched=1              /* [↑]  swapped one.*/
                            end   /*i*/
              if Asort//?==0  then call sleep switched   /*sleep if last*/
              end   /*Asort*/
return    /*Sleeping Beauty awakes.    Not to worry:   (c) = circa 1697.*/
/*───────────────────────────────────InOrder subroutine─────────────────*/
inOrder: procedure expose #.;  parse arg howMany   /*is array in order? */
          do m=1  for howMany-1;   next=m+1;  if #.m>#.next  then return 0
          end   /*m*/                 /*keep looking for fountain of yut*/
return 1                              /*yes, indicate with an indicator.*/
