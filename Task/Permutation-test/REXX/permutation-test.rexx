/*REXX program does a permutation test on  N + M  subjects (volunteers):*/
/*                                         ↑   ↑                        */
/*                                         │   │                        */
/*                                         │   └─────control  population*/
/*                                         └────────treatment population*/
n=9
data=85 88 75 66 25 29 83 39 97         68 41 10 49 16 65 32 92 28 98
w=words(data);    m=w-n
say 'volunteer population given treatment:' right(n,length(w))
say ' control  population given a placebo:' right(m,length(w))
say
say 'treatment population efficacy % (percentages):' subword(data,1,n)
say ' control  population placebo  % (percentages):' subword(data,n+1)
say
                     do v= 0 for w        ;    #.v=word(data,v+1) ;  end
treat=0;             do i= 0 to n-1       ;    treat=treat+#.i    ;  end
total=1;             do j=19 to m+1 by -1 ;    total=total*j      ;  end
                     do k= 9 to  1 by -1  ;    total=total/k      ;  end
gt=pick(n+m, n, 0)
le=total-gt
say "<= "  format(100*le/total,,3)'%'  le       /*show 3 decimal places.*/
say " > "  format(100*gt/total,,3)'%'  gt
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────PICK subroutine─────────────────────*/
pick:  procedure expose #. treat;      parse arg it,rest,eff
if rest==0  then return eff>treat
if it>rest  then q=pick(it-1, rest, eff)
            else q=0
itP=it-1
return pick(itP, rest-1, eff+#.itP) + q
