/*REXX pgm converts numbers (with commas) with suffix multipliers──►pure decimal numbers*/
numeric digits 2000                              /*allow the usage of ginormous numbers.*/
@.=; @.1= '2greatGRo   24Gros  288Doz  1,728pairs  172.8SCOre'
     @.2= '1,567      +1.567k    0.1567e-2m'
     @.3= '25.123kK    25.123m   2.5123e-00002G'
     @.4= '25.123kiKI  25.123Mi  2.5123e-00002Gi  +.25123E-7Ei'
     @.5= '-.25123e-34Vikki      2e-77gooGols'
     @.6=  9!   9!!   9!!!   9!!!!   9!!!!!   9!!!!!!   9!!!!!!!   9!!!!!!!!   9!!!!!!!!!

parse arg x                                      /*obtain optional arguments from the CL*/
if x\==''  then do;    @.2=;     @.1=x           /*use the number(s) specified on the CL*/
                end                              /*allow user to specify their own list.*/
                                                 /* [↓]  handle a list or multiple lists*/
    do  n=1  while @.n\=='';     $=              /*process each of the numbers in lists.*/
    say 'numbers= '      @.n                     /*echo the original arg to the terminal*/

        do j=1  for words(@.n);  y= word(@.n, j) /*obtain a single number from the input*/
        $= $  ' 'commas( num(y) )                /*process a number; add result to list.*/
        end   /*j*/                              /* [↑]  add commas to number if needed.*/
                                                 /* [↑]  add extra blank betweenst nums.*/
    say ' result= '      strip($);   say         /*echo the result(s) to the terminal.  */
    end       /*n*/                              /* [↑]  elide the  pre-pended  blank.  */
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
isInt:  return datatype( arg(1), 'Whole')        /*return 1 if arg is an integer,  or 0 */
isNum:  return datatype( arg(1), 'Number')       /*   "   "  "  "   " a  number.    " " */
p:      return word( arg(1), 1)                  /*pick 1st argument  or  2nd argument. */
ser:    say;   say '***error*** '  arg(1);           say;            exit 13
shorten:procedure; parse arg a,n;      return left(a,  max(0, length(a) - p(n 1) ) )
/*──────────────────────────────────────────────────────────────────────────────────────*/
$fact!: procedure; parse arg x _ .;    L= length(x);    n= L - length(strip(x, 'T', "!") )
        if n<=-n | _\=='' | arg()\==1  then return x;   z= left(x, L - n)
        if z<0 | \isInt(z)             then return x;   return $fact(z, n)
/*──────────────────────────────────────────────────────────────────────────────────────*/
$fact:  procedure; parse arg x _ .;  arg ,n ! .;     n= p(n 1);    if \isInt(n)  then n= 0
        if x<-n | \isInt(x) |n<1 | _||!\=='' |arg()>2  then return x||copies("!",max(1,n))
        s= x // n;   if s==0  then s= n          /*compute where to start multiplying.  */
        != 1                                     /*the initial factorial product so far.*/
                   do j=s  to x  by n;   != !*j  /*perform the actual factorial product.*/
                   end   /*j*/                   /*{operator  //  is REXX's ÷ remainder}*/
        return !                                 /* [↑]  handles any level of factorial.*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
$sfxa:  parse arg u,s 1 c,m;   upper u c         /*get original version & upper version.*/
        if pos( left(s, 2), u)\==0  then do j=length(s)   to compare(s, c)-1   by -1
                                         if right(u, j) \== left(c, j)  then iterate
                                         _= left(u, length(u) - j)        /*get the num.*/
                                         if isNum(_)  then return m * _   /*good suffix.*/
                                         leave                            /*return as is*/
                                         end
        return arg(1)                            /* [↑]  handles an alphabetic suffixes.*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
$sfx!:  parse arg y;                     if right(y, 1)=='!'  then y= $fact!(y)
        if \isNum(y)  then y=$sfxz();    if isNum(y)  then return y;       return $sfxm(y)
/*──────────────────────────────────────────────────────────────────────────────────────*/
$sfxm:  parse arg z 1 w;     upper w;    @= 'KMGTPEZYXWVU';                       b= 1000
        if right(w, 1)=='I'  then do;    z= shorten(z);      w= z;    upper w;    b= 1024
                                  end
        _= pos( right(w, 1), @);         if _==0      then return arg(1)
        n= shorten(z);  r= num(n, , 1);  if isNum(r)  then return r * b**_
        return arg(1)                            /* [↑]  handles metric or binary suffix*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
$sfxz:  return $sfxa( $sfxa( $sfxa( $sfxa( $sfxa( $sfxa(y, 'PAIRs', 2),   'DOZens', 12), ,
           'SCores', 20),   'GREATGRoss',  1728),     'GRoss', 144),     'GOOGOLs', 1e100)
/*──────────────────────────────────────────────────────────────────────────────────────*/
commas: procedure;  parse arg _;    n= _'.9';      #= 123456789;      b= verify(n, #, "M")
        e= verify(n, #'0', ,   verify(n, #"0.", 'M') )  -  4         /* [↑]  add commas.*/
           do j=e  to b  by -3;   _= insert(',', _, j);     end  /*j*/;           return _
/*──────────────────────────────────────────────────────────────────────────────────────*/
num:    procedure; parse arg x .,,q;         if x==''  then return x
        if  isNum(x)  then return  x/1;      x= space( translate(x, , ','), 0)
        if \isNum(x)  then x= $sfx!(x);      if isNum(x)  then return x/1
        if q==1  then return x
        if q==''  then call ser "argument isn't numeric or doesn't have a legal suffix:" x
