/*REXX program computes the factorial of a non-negative integer,  and   */
/* automatically adjusts the number of digits to accommodate the answer.*/

/*This version allows for faster multiplying of #s  (no trailing zeros).*/
numeric digits 100                    /*start with 100 digits.          */
numeric form                          /*indicates we want scientric form*/
parse arg n .;  if n==''  then n=0    /*get argument from command line. */

/*════════════════════════════════════where the rubber meets the road.  */
!=1                                   /*define factorial product so far.*/
     do j=2 to n                      /*compute factorial the hard way. */
     o!=!                             /*save old ! in case of overflow. */
     !=!*j                            /*multiple the factorial with  J, */
                                      /* and strip all trailing zeroes. */
     if pos('E',!)\==0 then do        /*is  !  in exponential notation? */
                            d=digits()               /*D is current digs*/
                            numeric digits d+d%10    /*add ten percent. */
                            !=o!*j    /*recalculate for the lost digit. */
                            end
     !=strip(!,'tail-end',0)          /*kill some electrons, strip 0's. */
     end                              /*(above) only 1st letter is used.*/
                                      /*let's perform some housekeeping.*/
if pos('E',!)\==0 then !=strip(!/1,"T",0)   /*! in exponential notation?*/
v=5;   tz=0
                    do while v<=n     /*calculate # of trailing zeroes. */
                    tz=tz+n%v
                    v=v*5
                    end  /*while v≤n*/
!=! || copies(0,tz)                   /*add some water to rehydrate  !. */
/*══════════════════════════════════════════════════════════════════════*/

say n'! is  ['length(!) "digits]:"    /*display # of digits in factorial*/
say                                   /*add some whitespace to output,  */
say !                                 /*  ... and display the ! product.*/
