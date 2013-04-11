/*REXX program converts (Arabic) decimal numbers (≥0) ──► Roman numerals*/
numeric digits 10000                         /*could be higher if wanted*/
parse arg nums

if nums='' then do                           /*not specified?  Gen some.*/
                         do j=0  by 11  to 111
                         nums=nums j
                         end   /*j*/
                nums=nums 49
                         do k=88  by 100  to 1200
                         nums=nums k
                         end   /*k*/
                nums=nums 1000 2000 3000 4000 5000 6000
                         do m=88  by 200  to 1200
                         nums=nums m
                         end   /*m*/
                nums=nums 1304 1405 1506 1607 1708 1809 1910 2011
                         do p=4  to 50       /*there is no limit to this*/
                         nums=nums 10**p
                         end   /*p*/
                end                          /*end generation of numbers*/

      do i=1  for words(nums);   x=word(nums,i)
      say right(x,55) dec2rom(x)
      end   /*i*/
exit                                   /*stick a fork in it, we're done.*/
/*───────────────────────────DEC2ROM subroutine─────────────────────────*/
dec2rom:  procedure;   parse arg n,#  /*get number, assign # to a null. */
n=space(translate(n,,','),0)          /*remove any commas from number.  */
nulla='ZEPHIRUM NULLAE NULLA NIHIL'   /*Roman words for nothing or none.*/
if n==0  then return word(nulla,1)    /*return a Roman word for zero.   */
maxnp=(length(n)-1)%3                 /*find max(+1) # of parens to use.*/
highPos=(maxnp+1)*3                   /*highest position of number.     */
nn=reverse(right(n,highPos,0))        /*digits for Arabic───►Roman conv.*/
nine=9
four=4;  do j=highPos  to 1  by -3
         _=substr(nn,j,1);    select
                              when _==nine   then hx='CM'
                              when _>=   5   then hx='D'copies("C",_-5)
                              when _==four   then hx='CD'
                              otherwise           hx=copies('C',_)
                              end
         _=substr(nn,j-1,1);  select
                              when _==nine   then tx='XC'
                              when _>=   5   then tx='L'copies("X",_-5)
                              when _==four   then tx='XL'
                              otherwise           tx=copies('X',_)
                              end
         _=substr(nn,j-2,1);  select
                              when _==nine   then ux='IX'
                              when _>=   5   then ux='V'copies("I",_-5)
                              when _==four   then ux='IV'
                              otherwise           ux=copies('I',_)
                              end
         xx=hx || tx || ux
         if xx\=='' then #=# ||copies('(',(j-1)%3)xx ||copies(')',(j-1)%3)
         end   /*j*/

if pos('(I',#)\==0 then do i=1  for 4     /*special case: M,MM,MMM,MMMM.*/
                        if i==4  then _ = '(IV)'
                                 else _ = '('copies("I",i)')'
                        if pos(_,#)\==0 then #=changestr(_,#,copies('M',i))
                        end   /*i*/
return #
