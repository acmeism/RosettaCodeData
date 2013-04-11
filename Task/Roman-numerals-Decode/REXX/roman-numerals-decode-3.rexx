/*REXX program to convert  Roman numerals ──► Arabic numerals (numbers).*/
numeric digits 1000                            /*we can handle big nums.*/
y = 'MCMXC'    ;      say right(y,9)':'  rom2dec(y)
y = 'mmviii'   ;      say right(y,9)':'  rom2dec(y)
y = 'MDCLXVI'  ;      say right(y,9)':'  rom2dec(y)
y = 'MDQLXVI'  ;      say right(y,9)':'  rom2dec(y)
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────ROM2DEC subroutine──────────────────*/
rom2dec:  procedure;   h='0'x;   #=0;   $=1;   arg n .    /*uppercase N.*/
n=translate(n,'()()',"[]{}");                  _ = verify(n,'MDCLXVUIJ()')
if _\==0  then return '***error!*** invalid Roman numeral:'  substr(n,_,1)
@.=1;   @.m=1000;   @.d=500;   @.c=100;   @.l=50;   @.x=10;  @.u=5;  @.v=5

   do k=length(n) to 1 by -1; _=substr(n,k,1)  /*examine a Roman numeral*/
                                               /*(next) scale up or down*/
   if _=='(' | _==')' then  do; $=$*1000; if _=='(' then $=1; iterate; end
   _=@._*$                                     /*scale it if necessary. */
   if _>h  then h=_                            /*remember Roman numeral.*/
   if _<h  then #=#-_                          /*char>next?  Then sub.  */
           else #=#+_                          /*            else add.  */
   end   /*k*/
return #                                       /*return Arabic number.  */
