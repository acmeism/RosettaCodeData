/*REXX program to show  modular exponentation:    a**b  mod  M          */
parse arg a b mm                            /*get the arguments (maybe).*/
if a=='' | a==',' then a=,
    2988348162058574136915891421498819466320163312926952423791023078876139

if b=='' | b==',' then b=,
    2351399303373464486466122544523690094744975233415544072992656881240319

if mm=='' then mm=40
say 'a=' a;           say '        ('length(a) "digits)"
say 'b=' b;           say '        ('length(b) "digits)"

      do j=1 for words(mm);   m=word(mm,j);   say copies('─',linesize()-1)
      say 'a**b (mod 10**'m")=" powerModulated(a,b,10**m)
      end   /*j*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────────POWERMODULATED subroutine───────*/
powerModulated: procedure;  parse arg x,p,n /*fast modular exponentation*/
if p==0  then return 1                      /*special case.             */
if p==1  then return x                      /*special case.             */
if p<0   then do;  say '***error!*** power is negative:' p;  exit 13;  end
parse value max(x**2,p,n)'E0'  with  "E" e  /*pick biggest of the three.*/
numeric digits max(20,e*2)                  /*big enough to handle  A²  */
_=1
          do while p\==0;   if p//2==1 then _=_*x//n
          p=p%2;     x=x*x // n
          end    /*while*/
return _
