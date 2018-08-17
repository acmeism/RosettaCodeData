/*REXX program finds the  median  of a  vector  (and displays the  vector  and  median).*/
/*  ══════════vector════════════   ══show vector═══   ════════show result═══════════    */
    v=  1 9 2 4                ;   say "vector"  v;   say 'median──────►' median(v);   say
    v=  3 1 4 1 5 9 7 6        ;   say "vector"  v;   say 'median──────►' median(v);   say
    v= '3 4 1 -8.4 7.2 4 1 1.2';   say "vector"  v;   say 'median──────►' median(v);   say
    v=  -1.2345678e99  2.3e700 ;   say "vector"  v;   say 'median──────►' median(v);   say
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
eSORT:  procedure expose @. #;     parse arg $;     #= words($)   /*$:  is the  vector. */
                do g=1  for #;   @.g= word($, g);   end  /*g*/    /*convert list──►array*/
        h=#                                                       /*#:  number elements.*/
                do  while  h>1;             h= h % 2              /*cut entries by half.*/
                   do i=1  for #-h;         j= i;        k= h + i /*sort lower section. */
                      do  while @.k<@.j;    parse value  @.j @.k  with  @.k @.j  /*swap.*/
                      if h>=j  then leave;  j= j - h;    k= k - h /*diminish  J  and  K.*/
                      end   /*while @.k<@.j*/
                   end      /*i*/
                end         /*while h>1*/                         /*end of exchange sort*/
        return
/*──────────────────────────────────────────────────────────────────────────────────────*/
median: procedure; call eSORT arg(1);   m= # % 2    /*   %   is REXX's integer division.*/
        n= m + 1                                    /*N:     the next element after  M. */
        if # // 2  then return @.n                  /*[odd?]   // ◄───REXX's ÷ remainder*/
                        return (@.m + @.n) / 2      /*process an  even─element  vector. */
