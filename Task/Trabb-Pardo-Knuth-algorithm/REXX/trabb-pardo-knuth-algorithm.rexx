/*REXX program implements the Trabb─Pardo-Knuth algorithm for N numbers (default is 11).*/
numeric digits 200                               /*the number of digits precision to use*/
parse arg N .;   if N=='' | N==","  then N=11    /*Not specified?  Then use the default.*/
maxValue= 400                                    /*the maximum value   f(x)   can have. */
     wid=  20                                    /*  ··· but only show this many digits.*/
    frac=   5                                    /*  ··· show this # of fractional digs.*/
say '                           _____'           /* ◄─── this  SAY  displays a vinculum.*/
say 'function:        ƒ(x)  ≡  √ │x│   +   (5 * x^3)'
prompt= 'enter '      N      " numbers for the Trabb─Pardo─Knuth algorithm:     (or Quit)"

  do ask=0;    say;  /*░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░*/
  say prompt;  say;      pull $;     say                                             /*░*/
  if abbrev('QUIT',$,1)  then do;    say 'quitting.';    exit 1;   end               /*░*/
  ok=0                                                                               /*░*/
                         select                  /*validate there're N numbers.*/    /*░*/
                         when $=''        then say  "no numbers entered"             /*░*/
                         when words($)<N  then say  "not enough numbers entered"     /*░*/
                         when words($)>N  then say  "too many numbers entered"       /*░*/
                         otherwise        ok=1                                       /*░*/
                         end   /*select*/                                            /*░*/
  if \ok  then iterate                                    /* [↓]  W=max width. */    /*░*/
  w=0;                   do v=1  for N;       _=word($, v);   w=max(w, length(_) )   /*░*/
                         if datatype(_, 'N')  then iterate          /*numeric ?*/    /*░*/
                         say _  "isn't numeric";   iterate ask                       /*░*/
                         end   /*v*/                                                 /*░*/
  leave                                                                              /*░*/
  end   /*ask*/      /*░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░*/

say 'numbers entered: '    $
say
        do i=N  by -1  for N;  #=word($, i) / 1  /*process the numbers in reverse.      */
        g =  fmt(   f( # )        )              /*invoke  function  ƒ  with arg number.*/
        gw=right(  'ƒ('#") ",  w+7)              /*nicely formatted  ƒ(number).         */
        if g>maxValue  then say gw    "is >  "     maxValue      ' ['space(g)"]"
                       else say gw     "   = "     g
        end   /*i*/                              /* [↑]  display the result to terminal.*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
f:    procedure;  parse arg x;           return  sqrt( abs(x) )    +    5 * x**3
/*──────────────────────────────────────────────────────────────────────────────────────*/
fmt:  z=right(translate(format(arg(1), wid, frac), 'e', "E"), wid) /*right adjust; use e*/
      if pos(.,z)\==0 then z=left(strip(strip(z,'T',0),"T",.),wid) /*strip trailing 0 &.*/
      return right(z, wid - 4*(pos('e', z)==0) )                   /*adjust: no exponent*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
sqrt: procedure; parse arg x; if x=0  then return 0; d=digits(); m.=9; numeric form; h=d+6
      numeric digits; parse value format(x,2,1,,0) 'E0'  with  g 'E' _ .;  g=g *.5'e'_ % 2
        do j=0  while h>9;      m.j=h;               h=h % 2  + 1;  end  /*j*/
        do k=j+5  to 0  by -1;  numeric digits m.k;  g=(g+x/g)*.5;  end  /*k*/;   return g
