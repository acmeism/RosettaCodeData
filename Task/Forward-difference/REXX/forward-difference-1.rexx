/*REXX program to compute the  forward difference  of a list of numbers.*/
/* ┌───────────────────────────────────────────────────────────────────┐
   │              /\                   n     n         n-k             │
   │ {delta}     /  \ n  [ƒ] (x)   ≡   Σ    Ç   ∙  (-1)     ∙  ƒ(x+k)  │
   │            /____\                k=0    k                         │
   │                                                                   │
   │                 {n=order}             {Ç=comb or binomial coeff.} │
   └───────────────────────────────────────────────────────────────────┘*/
numeric digits 100                     /*ensure enough accuracy.        */
arg numbers ',' ord                     /*input:  x1 x2 x3 x4 ...  ,ORD */
if numbers=='' then numbers='90 47 58 29 22 32 55 5 55 73'    /*default?*/
w=words(numbers)                       /*set W to  # of numbers in list.*/

          do i=1  for w                /*validate input (valid numbers?)*/
          @.i=word(numbers,i)          /*assign the next # in the list. */
          if \datatype(@.i,'N')  then call ser @.i "isn't a valid number"
          @.i=@.i/1                    /*normalize the #, prettify the #*/
          end   /*i*/
/*═════════════════════════════════════════process the (optional) input.*/
if w==0                 then call ser 'no numbers were specified'
if ord\=='' & ord<0     then call ser ord "(ner) can't be negative"
if ord\=='' & ord>w     then call ser ord "(ner) can't be greater than" w
say right(w 'numbers: ' numbers,64)    /*sloppy way to do a header, ... */
say right(copies('─',length(numbers)),64)       /* and the header fence.*/
if ord==''  then do;   bot=0;   top=w;   end    /*define default ners.*/
            else do;   bot=n;   top=n;   end    /*just a specific ner?*/
/*═════════════════════════════════════════where da rubber meets da road*/
      do order=bot  to top;            do r=1  for w; !.r=@.r; end;     $=
        do j=1  for order;   d=!.j;    do k=j+1  to w      /*order diff.*/
                                       parse value !.k !.k-d with d !.k
                                       end   /*k*/
        end   /*j*/
                                       do i=order+1  to w  /*build list.*/
                                       $=$ !.i/1           /*append it. */
                                       end   /*i*/
      if $=='' then $='[null]'                             /*pretty null*/
          what=right(order,length(w))th(order)'-order'     /*nice format*/
      say what 'forward difference vector = ' strip($)     /*display it.*/
      end      /*o*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────SER subroutine──────────────────────*/
ser:   say;     say '*** error! ***';     say arg(1);     say;     exit 13
/*──────────────────────────────────TH subroutine───────────────────────*/
th: parse arg ?; return word('th st nd rd',1+?//10*(?//100%10\==1)*(?//10<4))
