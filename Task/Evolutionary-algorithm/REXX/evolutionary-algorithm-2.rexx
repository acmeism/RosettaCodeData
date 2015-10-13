/*REXX program demonstrates an evolutionary algorithm  (by using mutation).   */
parse arg  children  MR  seed .        /*get optional arguments from the C.L. */
if children==''  then children = 10    /*# children produced each generation. */
if MR      ==''  then MR       = '4%'  /*the character Mutation Rate each gen.*/
if right(MR,1)=='%'  then MR=strip(MR,,'%')/100  /*expressed as %? Then adjust*/
if seed\==''  then call random ,,seed  /*SEED allow the runs to be repeatable.*/
abc = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ ';     Labc=length(abc)

       do i=0  for Labc                /*define array  (for faster compare),  */
       @.i=substr(abc,i+1,1)           /*     it's better than picking out a  */
       end   /*i*/                     /*     byte from a character string.   */

target= 'METHINKS IT IS LIKE A WEASEL' ;    Ltar=length(target)

       do i=1  for Ltar                /*define an array (for faster compare),*/
       T.i=substr(target,i,1)          /*     it's better than a byte-by-byte */
       end   /*i*/                     /*     compare using character strings.*/

parent= mutate( left('',Ltar), 1)      /*gen rand string, same length as tar. */
say center('target string',Ltar,'─')    "children"    'mutationRate'
say target  center(children,8)   center((MR*100/1)'%',12);               say
say center('new string',Ltar,'─')   "closeness"   'generation'

       do gen=0  until  parent==target;            close=fitness(parent)
       almost=parent
                         do  children;             child=mutate(parent,MR)
                         _=fitness(child);         if _<=close  then iterate
                         close=_;                  almost=child
                         say almost  right(close,9)  right(gen,10)
                         end   /*children*/
       parent=almost
       end   /*gen*/
exit                                   /*stick a fork in it,  we're all done. */
/*────────────────────────────────────────────────────────────────────────────*/
fitness: parse arg x;  $=0;    do k=1  for Ltar;  $=$+(substr(x,k,1)==T.k);  end
         return $
/*────────────────────────────────────────────────────────────────────────────*/
mutate:  parse arg x,rate              /*set  X  to 1st argument, RATE to 2nd.*/
         $=;       do j=1  for Ltar;        r=random(1,100000)   /*REXX's max.*/
                   if .00001*r<=rate  then do;    _=r//Labc;    $=$ || @._;  end
                                      else $=$ || substr(x,j,1)
                   end   /*j*/
         return $
