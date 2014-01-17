/*REXX program validates  credit card numbers  via the  Luhn  algorithm.*/
cc.  =;          @@='the Luhn test for a credit card number.'  /*literal*/
cc.1 = 49927398716                     /*sample credit card number one. */
cc.2 = 49927398717                     /*   "      "     "     "   two. */
cc.3 = 1234567812345678                /*   "      "     "     "   three*/
cc.4 = 1234567812345670                /*   "      "     "     "   four.*/
              do k=1  while cc.k\==''  /*process all the credit card #s.*/
              say right(cc.k, 30)  LuhnTest(cc.k)  @@    /*see if valid.*/
              end   /*k*/              /* [↑] show if it passed/flunked.*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────LUHNTEST subroutine─────────────────*/
LuhnTest: procedure;  parse arg t; s=0 /*get credit card#, set S to zero*/
t=reverse(left(0,length(t)//2)t)       /*add leading 0 if needed,reverse*/
                      do j=1  to length(t)-1  by 2;    q=2*substr(t,j+1,1)
                      s=s + substr(t,j,1) + left(q,1) + substr(q,2,1,0)
                      end   /*j*/      /* [↑]   sum odd and even digits.*/
if s//10==0  then return 'passed '     /*if ending in zero, then passed.*/
             else return 'flunked'     /*if ¬ ending in 0,  not so good.*/
