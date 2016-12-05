/*REXX program  validates  credit card numbers  using  the    Luhn    algorithm.        */
@luhnCCN= ' the Luhn test, credit card number: ' /*literal for displaying passed/flunked*/
#.=;                #.1=49927398716              /*the  1st  sample credit card number. */
                    #.2=49927398717              /* "   2nd     "      "     "     "    */
                    #.3=1234567812345678         /* "   3rd     "      "     "     "    */
                    #.4=1234567812345670         /* "   4th     "      "     "     "    */
      do k=1  while #.k\==''                     /*validate all the credit card numbers.*/
      say right(Luhn(#.k),9)    @luhnCCN    #.k  /*display if number passed or flunked. */
      end   /*k*/                                /* [↑] function returns passed│flunked.*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
Luhn: procedure;  parse arg x;       $=0         /*get credit card number;  zero $ sum. */
      y=reverse(left(0, length(x) // 2)x)        /*add leading zero if needed, reverse. */
               do j=1  to length(y)-1  by 2;            _=2*substr(y,j+1,1)
               $=$ + substr(y,j,1) + left(_,1) + substr(_,2,1,0)
               end   /*j*/                       /* [↑]   sum the  odd and even  digits.*/
      return word('passed flunked',1+($//10==0)) /*$ ending in zero?  Then the # passed.*/
