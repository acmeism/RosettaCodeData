/*REXX program to generate and display a number of narcissistic numbers.*/
numeric digits 39                      /*be able to handle the largest #*/
parse arg N .;  if N==''  then N=25    /*get number of narcissistic #'s.*/
N=min(N,89)                            /*there are  89  narcissistic #s.*/
   do w=1  for 39                      /*generate tables: digits ^ L pow*/
     do i=0  for 10;  @.w.i=i**w;  end /*build table of 10 digs ^ L pow.*/
   end   /*w*/                         /* [↑]  table is of a fixed size.*/
#=0                                    /*number of narcissistic # so far*/
   do low=0 for 10; call tell low; end /*handle the first one-digit nums*/
                                       /* [↓]  skip the 2-digit numbers.*/
     do j=100;      L=length(j)        /*get the length of the J number.*/
     _1=left(j,1); _2=substr(j,2,1)    /*select 1st & 2nd digit to sum. */
     _R=right(j,1)                     /*select the right digit to sum. */
     s=@.L._1 + @.L._2 + @.L._R        /*sum of the J digs ^ L  (so far)*/
             do k=3  for L-3 until s>j /*perform for each digit in  J.  */
             _=substr(j,k,1)           /*select the next digit to sum.  */
             s=s + @.L._               /*add digit raised to pow to sum.*/
             end   /*k*/               /* [↑]  calculate the rest of sum*/
     if s==j  then call tell j         /*does sum equal to  J?   Yes ···*/
     end   /*j*/                       /* [↑]    this list starts at 0. */
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────TELL subroutine─────────────────────*/
tell:  parse arg y                     /*get narcissistic # to display. */
#=#+1                                  /*bump the narcissistic # count. */
say right(#,9)   ' narcissistic:'   y  /*display index & narcissistic #.*/
if #==N  then exit                     /*stick a fork in it, we're done.*/
return                                 /*return and keep on truckin'.   */
