/*REXX program to implement the  Trabb─Pardo-Knuth  algorithm for  N  numbers.*/
N=11                                   /*N is the number of numbers to be used*/
maxValue=400                           /*the maximum value   f(x)   can have. */
compDigs=200                           /*compute with this many decimal digits*/
showDigs=20                            /*  ··· but only show this many digits.*/
numeric digits compDigs                /*the number of digits precision to use*/
say '                           _____               '              /*vinculum.*/
say 'function:        ƒ(x)  ≡  √ │x│   +   (5 * x^3)'
prompt= 'enter '  N  " numbers for the Trabb─Pardo─Knuth algorithm:   (or Quit)"
/*▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ */
  do ask=0;        say;    say prompt;     say;     pull $;   say                  /* ▒ */
  if abbrev('QUIT',$,1)  then exit     /*does the user want to QUIT this pgm? */   /* ▒ */
  ok=0                                                                             /* ▒ */
                         select        /*validate that there are  N  numbers. */   /* ▒ */
                         when $=''        then say  'no numbers entered'           /* ▒ */
                         when words($)<N  then say  'not enough numbers entered'   /* ▒ */
                         when words($)>N  then say  'too many numbers entered'     /* ▒ */
                         otherwise        ok=1                                     /* ▒ */
                         end   /*select*/                                          /* ▒ */
  if \ok  then iterate                                    /* [↓]  is max width*/   /* ▒ */
  w=0;                   do v=1  for N;      _=word($,v);     w=max(w,length(_))   /* ▒ */
                         if datatype(_,'N')  then iterate         /*numeric ? */   /* ▒ */
                         say _  "isn't numeric";  iterate ask                      /* ▒ */
                         end   /*v*/                                               /* ▒ */
  leave                                                                            /* ▒ */
  end  /*ask*/                                                                     /* ▒ */
say 'numbers entered: '  $;                      say                               /* ▒ */
/*▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ */
        do i=N  by -1  to 1;   #=word($,i)/1       /*process nums in reverse. */
        numeric digits compDigs;    g=f(#)         /*for func. ƒ, use big digs*/
        numeric digits showdigs;    g=g/1          /*scale down output digits.*/
        gw=right('ƒ('#") ",w+7)                    /*nice formatted  ƒ(number)*/
        if g>maxValue  then say gw "is > "       maxValue     '  ['g"]"
                       else say gw " = "   g       /*display the (good) result*/
        end   /*i*/
exit                                   /*stick a fork in it,  we're all done. */
/*────────────────────────────────────────────────────────────────────────────*/
f:    procedure;  parse arg x;           return  sqrt(abs(x))    +    5 * x**3
/*────────────────────────────────────────────────────────────────────────────*/
sqrt: procedure; parse arg x;   if x=0  then return 0;  d=digits();  i=;   m.=9
      numeric digits 9; numeric form; h=d+6;  if x<0  then  do; x=-x; i='i'; end
      parse value format(x,2,1,,0) 'E0'  with  g 'E' _ .;       g=g*.5'e'_%2
         do j=0  while h>9;      m.j=h;              h=h%2+1;         end  /*j*/
         do k=j+5  to 0  by -1;  numeric digits m.k; g=(g+x/g)*.5;    end  /*k*/
      numeric digits d;     return (g/1)i            /*make complex if  X < 0.*/
