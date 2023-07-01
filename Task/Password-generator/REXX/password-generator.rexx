/*REXX program generates a  random password  according to the Rosetta Code task's rules.*/
@L='abcdefghijklmnopqrstuvwxyz'; @U=@L; upper @U /*define lower-, uppercase Latin chars.*/
@#= 0123456789                                   /*   "   " string of base ten numerals.*/
@@= '!"#$%&()+,-./:;<=>?@[]^{|}~' || "'"         /*define a bunch of special characters.*/
parse arg L N seed xxx yyy .                     /*obtain optional arguments from the CL*/
if L=='?'               then signal help         /*does user want documentation shown?  */
if L=='' | L==","       then L=8                 /*Not specified?  Then use the default.*/
if N=='' | N==","       then N=1                 /* "      "         "   "   "     "    */
if xxx\==''             then call weed  xxx      /*Any chars to be ignored?  Scrub lists*/
if yyy\==''             then call weed  x2c(yyy) /*Hex   "    "  "     "       "     "  */
if  datatype(seed,'W')  then call random ,,seed  /*the seed for repeatable RANDOM BIF #s*/
if \datatype(L,   'W')  then call serr  "password length, it isn't an integer: "       L
if L<4                  then call serr  "password length, it's too small  (< 4): "     L
if L>80                 then call serr  "password length, it's too large  (> 80): "    L
if \datatype(N,   'W')  then call serr  "number of passwords, it isn't an integer: "   N

    do g=1  to N;       $=                       /*generate N passwords (default is one)*/
        do k=1  for L;       z=k;   if z>4  then z=random(1,4) /*1st four parts │ random*/
        if z==1  then $=$ || substr(@L,random(1,length(@L)),1) /*append lowercase letter*/
        if z==2  then $=$ || substr(@U,random(1,length(@U)),1) /*   "   uppercase    "  */
        if z==3  then $=$ || substr(@#,random(1,length(@#)),1) /*   "    numeral        */
        if z==4  then $=$ || substr(@@,random(1,length(@@)),1) /*   "  special character*/
        end   /*k*/
                                                 /* [↓]  scrambles PW, hides gen order. */
        do a=1  for L;          b=random(1, L)   /*swap every character with another.   */
        parse var $ =(a) x +1 =(b)  y  +1        /*≡  x=substr($,a,1);  y=substr($,b,1) */
        $=overlay(x,$,b);       $=overlay(y,$,a) /*(both statements) swap two characters*/
        end  /*L+L*/                             /* [↑]  more swaps obfuscates gen order*/

    say right(g, length(N))  'password is: '  $  /*display the  Nth  password to console*/
    /*      call lineout 'GENPW.PW', $  */       /*and also write the password to a file*/     /*or not.*/
    end      /*g*/                               /* [↑]  {a comment}   fileID= GENPW.PW */
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
weed:  parse arg ig;   @L=dont(@L);   @U=dont(@U);   @#=dont(@#);   @@=dont(@@);    return
dont:  return space( translate(arg(1), , ig), 0)              /*remove chars from a list*/
serr:  say;   say '***error*** invalid'  arg(1);  exit 13     /*display an error message*/
help:  signal .; .: do j=sigL+1 to sourceline(); say strip(left(sourceline(j),79)); end /*
╔═════════════════════════════════════════════════════════════════════════════╗
║  GENPW  ?                    ◄─── shows this documentation.                 ║
║  GENPW                       ◄─── generates 1 password  (with length  8).   ║
║  GENPW len                   ◄─── generates (all) passwords with this length║
║  GENPW  ,   n                ◄─── generates     N      number of passwords. ║
║  GENPW  ,   ,  seed          ◄─── generates passwords  using a random seed. ║
║  GENPW  ,   ,    ,  xxx      ◄─── generates passwords that don't contain xxx║
║  GENPW  ,   ,    ,   ,  yyy  ◄─── generates passwords that don't contain yyy║
║                                                                             ║
╟──────────── where   [if a  comma (,)  is specified,  the default is used]:  ║
║ len     is the length of the passwords to be generated.    The default is 8.║
║         The minimum is  4,   the maximum is  80.                            ║
║ n       is the number of passwords to be generated.        The default is 1.║
║ seed    is an integer seed used for the RANDOM BIF.     (Default is random.)║
║ xxx     are characters to  NOT  be used for generating passwords.           ║
║         The default is to use  all  the  (normal)  available characters.    ║
║ yyy     (same as XXX,  except the chars are expressed as hexadecimal pairs).║
╚═════════════════════════════════════════════════════════════════════════════╝         */
