/*REXX program to show  various   (integer)  exponentiations.           */
                                say center('digits='digits(),79,'─')
say '17**65   is:'
say  17**65

numeric digits 100;    say;     say center('digits='digits(),79,'─')
say '17**65   is:'
say  17**65

numeric digits 10;     say;     say center('digits='digits(),79,'─')
say '2 ** -10   is:'
say  2 ** -10

numeric digits 30;     say;     say center('digits='digits(),79,'─')
say '-3.1415926535897932384626433 ** 3  is:'
say  -3.1415926535897932384626433 ** 3

numeric digits 1000;   say;     say center('digits='digits(),79,'─')
say '2 ** 1000   is:'
say  2 ** 1000

numeric digits 60;     say;     say center('digits='digits(),79,'─')
say 'ipow(5,70)  is:'
say  ipow(5,70)
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────ERRIPOW subroutine──────────────────*/
errIpow: say;  say '***error!***';  say;  say arg(1);  say;  say;  exit 13
/*──────────────────────────────────IPOW subroutine─────────────────────*/
ipow:  procedure;  parse arg x 1 _,p
if arg()<2           then call erripow 'not enough arguments specified'
if arg()>2           then call erripow 'too many arguments specified'
if \datatype(_,'N')  then call erripow "1st arg isn't numeric:" _
if \datatype(p,'W')  then call erripow "2nd arg isn't an integer:" p
if p=0               then return 1
pa=abs(p)
                     do pa-1;   _=_*x;   end
if p<0 then _=1/_
return _
