/*REXX program produces & displays a  power tree  for P,  and calculates & displays X^P.*/
numeric digits 1000                              /*be able to handle some large numbers.*/
parse arg XP                                     /*get sets:   X, low power, high power.*/
if XP=''  then XP='2 -4 17   3 191 191   1.1 81' /*Not specified?  Then use the default.*/
          /*────── X LP HP   X  LP  HP    X  LP  ◄── X, low power, high power ··· repeat*/
     do  until XP=''
     parse var XP    x pL pH   XP;    x= x / 1   /*get X, lowP, highP; and normalize X. */
     if pH=''  then pH= pL                       /*No highPower?  Then assume lowPower. */

       do e=pL  to pH;           p= abs(e) / 1   /*use a range of powers;   use  │E│    */
       $= powerTree(p);          w= length(pH)   /*construct the power tree, (pow list).*/
                                                 /* [↑]  W≡length for an aligned display*/
          do i=1  for words($);  @.i= word($, i) /*build a fast Knuth's power tree array*/
          end   /*i*/

       if p==0  then do;  z= 1;  call show;  iterate;  end  /*handle case of zero power.*/
       !.= .;   z= x;     !.1= z;     prv= z     /*define/construct the first power of X*/

           do k=2  to words($);       n= @.k     /*obtain the power (number) to be used.*/
           prev= k - 1;     diff= n - @.prev     /*these are used for the odd powers.   */
           if n//2==0  then z= prv ** 2          /*Even power?   Then square the number.*/
                       else z= z * !.diff        /* Odd   "        "  mult. by pow diff.*/
           !.n= z                                /*remember for other multiplications.  */
           prv= z                                /*remember for squaring the numbers.   */
           end   /*k*/
       call show                                 /*display the expression and its value.*/
       end       /*e*/
     end         /*until XP ···*/
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
powerTree: arg y 1 oy;   $=                      /*Z is the result; $ is the power tree.*/
           if y=0 | y=1  then return y           /*handle special cases for zero & unity*/
           #.= 0;   @.= 0;    #.0= 1             /*define default & initial array values*/
                                                 /* [↓]  add blank "flag" thingy──►list.*/
                   do  while \(y//2);  $= $ ' '  /*reduce "front" even power #s to odd #*/
                   if y\==oy  then $= y $        /*(only)  ignore the first power number*/
                   y= y % 2                      /*integer divide the power (it's even).*/
                   end   /*while*/

           if $\==''  then $= y $                /*re─introduce the last power number.  */
           $= $ oy                               /*insert last power number 1st in list.*/
           if y>1  then do      while  @.y==0;            n= #.0;        m= 0
                          do    while  n\==0;             q= 0;          s= n
                            do  while  s\==0;             _= n + s
                            if @._==0  then do;  if q==0  then m_= _;
                                                 #._= q;  @._= n;        q= _
                                            end
                            s= @.s
                            end   /*while s¬==0*/
                          if q\==0  then do;   #.m= q;   m= m_;   end
                          n= #.n
                          end     /*while n¬==0*/
                        #.m= 0
                        end       /*while @.y==0*/
           z= @.y
                            do  while z\==0;   $= z $;   z= @.z;  end /*build power list*/
           return space($)                                            /*del extra blanks*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
show: if e<0  then z=format(1/z, , 40)/1;     _=right(e, w)           /*use reciprocal? */
      say left('power tree for '  _  " is: "  $,60)  '═══'  x"^"_  ' is: '  z;      return
