/*REXX pgm orders some items based on (correct) answers from a  carbon─based life form. */
colors= 'violet red green indigo blue yellow orange'
                                        q= 0;    #= 0;    $=
           do j=1  for words(colors);   q= inSort( word(colors, j), q)
           end   /*j*/                           /*poise questions the CBLF about order.*/
say
           do i=1  for #;   say '   query'   right(i, length(#) )":"   !.i
           end   /*i*/                           /* [↑] show the list of queries to CBLF*/
say
say 'final ordering: '    $
exit 0
/*──────────────────────────────────────────────────────────────────────────────────────*/
getAns: #= # + 1;    _= copies('─', 8);     y_n= '     Answer  y/n'
              do try=0  until ansU='Y'  |  ansU='N'
              if try>0  then say _ '(***error***)  incorrect answer.'
              ask= _  ' is '   center(x,6)   " less than "   center(word($, mid+1),6)  '?'
              say ask   y_n;  parse pull ans 1 ansU;   ansU= space(ans);   upper ansU
              end   /*until*/;      !.#= ask   '  '    ans;                return
/*──────────────────────────────────────────────────────────────────────────────────────*/
inSort: parse arg x, q;          hi= words($);          lo= 0
              do q=q-1  while lo<hi;              mid= (lo+hi) % 2
              call getAns;  if ansU=='Y'  then hi= mid
                                          else lo= mid + 1
              end   /*q*/
        $= subword($, 1, lo)  x  subword($, lo+1);      return q
