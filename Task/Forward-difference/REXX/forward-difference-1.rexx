    butchers/mangles some of the characters in the documentation box. -->
<lang>/*REXX program  computes the  forward difference  of a  list of numbers.
  ╔════════════════════════════════════════════════════════════════════╗
  ║             /\                     n     n         n-k             ║
  ║            /  \  n  [ƒ] (x)   ≡    Σ    C   ∙  (-1)     ∙  ƒ(x+k)  ║
  ║           /____\                  k=0    k                         ║
  ║             ↑    ↑                      ↑                          ║
  ║             │    │                      │                          ║
  ║ {delta}─────┘   {n=order}              {C=comb or binomial coeff.} ║
  ╚════════════════════════════════════════════════════════════════════╝*/
numeric digits 100                     /*ensure enough accuracy (digits)*/
parse arg xxx ',' N                    /*input:  ε1 ε2 ε3 ε4 ··· , order*/
if xxx==''  then xxx='90 47 58 29 22 32 55 5 55 73'   /*default numbers.*/
w=words(xxx)                           /*set W to  # of numbers in list.*/
                                       /* [↓] validate the input numbers*/
          do i=1  for w; _=word(xxx,i) /*process each number 1 at a time*/
          if \datatype(_,'N')  then call ser   _   "isn't a valid number"
          @.i=_/1                      /*normalize the #, prettify the #*/
          end   /*i*/                  /* [↑]  removes superfluous stuff*/
                                       /* [↓]  process (optional) order.*/
if w==0           then call ser 'no numbers were specified.'
if N\=='' & N<0   then call ser N  "(order) can't be negative."
if N\=='' & N>w   then call ser N  "(order) can't be greater than"  w
say right(w 'numbers:', 44)  xxx               /*display the header ··· */
say left('', 44)copies('─', length(xxx)+2)     /*  and the header fence.*/
if N==''  then do;  bot=0;  top=w;  end        /*define default orders. */
          else do;  bot=N;  top=N;  end        /*just a specific order? */
/*═════════════════════════════════════════where da rubber meets da road*/
      do #=bot  to top;             do r=1  for w;  !.r=@.r;  end;      $=
        do j=1  for #;   d=!.j;     do k=j+1  to w
                                    parse  value  !.k !.k-d   with   d !.k
                                    end   /*k*/
        end   /*j*/
                                    do i=#+1  to w;    $=$ !.i/1;    end
      if $==''  then $='[null]'
      say right(#, 7)th(#)'-order forward difference vector = '  strip($)
      end      /*o*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────one─liner subroutines───────────────*/
ser:  say;       say '***error!***';      say arg(1);     say;     exit 13
th:   arg ?;  return word('th st nd rd',1+?//10*(?//100%10\==1)*(?//10<4))
