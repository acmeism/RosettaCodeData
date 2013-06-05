/*REXX program demonstrates an evolutionary algorithm  (using mutation).*/
parse arg  children  MR  seed .        /*get options (maybe) from  C.L. */
if children=='' then children = 10     /*# of children produced each gen*/
if MR      =='' then MR       = "4%"   /*the char Mutation Rate each gen*/
if right(MR,1)=='%' then MR=strip(MR,,"%")/100  /*expressed as %? Adjust*/
if seed\==''  then call random ,,seed  /*allow the runs to be repeatable*/
abc   = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ '  ;    Labc=length(abc)

       do i=0  for Labc                /*define array (faster compare), */
       A.i=substr(abc, i+1, 1)         /* it's better than picking out a*/
       end   /*i*/                     /* byte from a character string. */

target= 'METHINKS IT IS LIKE A WEASEL' ;    Ltar=length(target)

       do i=1  for Ltar                /*define array (faster compare), */
       T.i=substr(target, i, 1)        /*it's better than a byte-by-byte*/
       end   /*i*/                     /*compare using character strings*/

parent= mutate( left('', Ltar), 1)     /*gen rand str,same length as tar*/
say center('target string', Ltar, '─')  "children"  'mutationRate'
say target center(children, 8)   center((MR*100/1)'%', 12)        ;   say
say center('new string', Ltar, '─')  "closeness"  'generation'

       do gen=0  until  parent==target;      close=fitness(parent)
       almost=parent
                         do  children;       child=mutate(parent, MR)
                         _=fitness(child);   if _<=close  then iterate
                         close=_;            almost=child
                         say  almost   right(close, 9)   right(gen, 10)
                         end   /*children*/
       parent=almost
       end   /*gen*/
exit                                   /*stick a fork in it, we're done.*/
/*───────────────────────────────────FITNESS subroutine─────────────────*/
fitness: parse arg x; hit=0;   do k=1  for Ltar
                               hit=hit  +  (substr(x,k,1) == T.k)
                               end   /*k*/
return hit
/*───────────────────────────────────MUTATE subroutine──────────────────*/
mutate:  parse arg x,rate,?            /*set  ?  to a null,  x=string.  */
            do j=1  for Ltar;              r=random(1, 100000)
            if .00001*r<=rate  then do;    _=r//Labc;    ?=? || A._;   end
                               else ?=? || substr(x,j,1)
            end   /*j*/
return ?
