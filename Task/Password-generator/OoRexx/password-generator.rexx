/*REXX program generates a  random password  according to the Rosetta Code task's rules.*/
parse arg L N seed xxx dbg                       /*obtain optional arguments from the CL*/
casl= 'abcdefghijklmnopqrstuvwxyz'               /*define lowercase alphabet.           */
casu= translate(casle)                           /*define uppercase alphabet.           */
digs= '0123456789'                               /*define digits.                       */
/* avoiding the ambiguous characters Il1 o0 5S                                          */
casl= 'abcdefghijkmnpqrtuvwxy'                   /*define lowercase alphabet.           */
casu= translate(casl)                            /*define uppercase alphabet.           */
digs= '0123456789'                               /*define digits.                       */
spec= '''!"#$%&()+,-./:;<=>?@[]^{|}~'            /*define a bunch of special characters.*/
if L='?'               then call help            /*does user want documentation shown?  */
if L=''  | L=","       then L=8                  /*Not specified?  Then use the default.*/
If N=''  | N=","       then N=1                  /* "      "         "   "   "     "    */
If xxx=''| xxx=","     then xxx='1lI0O2Z5S'      /* "      "         "   "   "     "    */
if seed>'' &,
   seed<>','            then Do
  if \datatype(seed,'W')then call ser "seed is not an integer:" seed
  Call random ,,seed                             /*the seed for repeatable RANDOM BIF #s*/
  End
casl=remove(xxx,casl)
casu=remove(xxx,casu)
digs=remove(xxx,digs)
Say 'casl='casl
Say 'casu='casu
Say 'digs='digs
Say 'spec='spec
if \datatype(L,   'W')  then call ser "password length, it isn't an integer: "       L
if L<4                  then call ser "password length, it's too small: "            L
if L>80                 then call ser "password length, it's too large: "            L
if \datatype(N,   'W')  then call ser "number of passwords, it isn't an integer: "   N
if N<0                  then call ser "number of passwords, it's too small: "        N

    do g=1  for N                                /*generate  N  passwords (default is 1)*/
    pw=letterL()||letterU()||numeral()||special()/*generate  4  random  PW constituents.*/
            do k=5  to  L;       z=random(1, 4)  /* [?]  flush out PW with more parts.  */
            if z==1  then pw=pw || letterL()     /*maybe append random lowercase letter.*/
            if z==2  then pw=pw || letterU()     /*  "      "      "   uppercase    "   */
            if z==3  then pw=pw || numeral()     /*  "      "      "       numeral      */
            if z==4  then pw=pw || special()     /*  "      "      "   special character*/
            end   /*k*/                          /* [?]  code below randomizes PW chars.*/
    t=length(pw)                                 /*the length of the password (in bytes)*/
            do L+L                               /*perform a random number of char swaps*/
            a=random(1,t);     x=substr(pw,a,1)  /*A: 1st char location;  X is the char.*/
            b=random(1,t);     y=substr(pw,b,1)  /*B: 2nd   "      "      Y  "  "    "  */
            pw=overlay(x,pw,b);  pw=overlay(y,pw,a)  /* swap the two chars.             */
            end  /*swaps*/                       /* [?]  perform extra swap to be sure. */
    say right(g,length(N))  'password is: ' pw counts() /*display the  Nth  password    */
    end       /*g*/
exit                                             /*stick a fork in it,  we're all done. */
/*--------------------------------------------------------------------------------------*/
ser:      say;   say '***error*** invalid' arg(1);  exit 13   /*display an error message*/
letterL:  return substr(casl, random(1, length(casl)), 1)   /*return random lowercase.*/
letterU:  return substr(casu, random(1, length(casu)), 1)   /*   "      "   uppercase.*/
numeral:  return substr(digs, random(1, length(digs)), 1)   /*   "      "    numeral. */
special:  return substr(spec, random(1, length(spec)), 1)   /*   "      " special char*/
remove: Procedure
  Parse arg nono,s
  Return space(translate(s,'',nono),0)
/*--------------------------------------------------------------------------------------*/
counts:
  If dbg>'' Then Do
    cnt.=0
    str.=''
    Do j=1 To length(pw)
      c=substr(pw,j,1)
      If pos(c,casL)>0 Then Do; cnt.0casL=cnt.0casL+1; str.0casL=str.0casL||c; End
      If pos(c,casU)>0 Then Do; cnt.0casU=cnt.0casU+1; str.0casU=str.0casU||c; End
      If pos(c,digs)>0 Then Do; cnt.0digs=cnt.0digs+1; str.0digs=str.0digs||c; End
      If pos(c,spec)>0 Then Do; cnt.0spec=cnt.0spec+1; str.0spec=str.0spec||c; End
      End
    txt=cnt.0casL cnt.0casU cnt.0digs cnt.0spec
    If pos(' 0 ',txt)>0 Then
      txt=txt 'error'
    Return txt str.0casL str.0casU str.0digs str.0spec
    End
  Else
    txt=''
  Return txt
help:     signal .; .:   do j=sigL+2  to sourceline()-1; say sourceline(j); end;    exit 0
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~ documentation begins on next line.~~~~~~~~~~~~~~~~~~~~~~~~~
+-----------------------------------------------------------------------------+
¦ Documentation for the  GENPW  program:                                      ¦
¦                                                                             ¦
¦ Rexx genpwd <length|,> <howmany|,> <seed|,> <xxx|,>     <dbg>               ¦
¦                     8           1     n     '1lI0O2Z5S'  none    Defaults   ¦
¦                                                                             ¦
¦--- where:                                                                   ¦
¦           length      is the length of the passwords to be generated.       ¦
¦                       The default is  8.                                    ¦
¦                       If a  comma (,)  is specified, the default is used.   ¦
¦                       The minimum is  4,   the maximum is  80.              ¦
¦                                                                             ¦
¦           howMany     is the number of passwords to be generated.           ¦
¦                       The default is  1.                                    ¦
¦           xxx         Characters NOT to be used in generated passwords      ¦
¦           dbg         Schow count of characters in the 4 groups             ¦
+-----------------------------------------------------------------------------+
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~documentation ends on the previous line.~~~~~~~~~~~~~~~~~~~*/
