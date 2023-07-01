/*REXX program computes the  Jaro distance  between two strings  (or a list of strings).*/
@.=                                              /*define a default for the  @.  array. */
parse arg @.1                                    /*obtain an optional character string. */
if @.1=''  then do;  @.1= 'MARTHA     MARHTA'    /*Nothing specified?  Use the defaults.*/
                     @.2= 'DIXON      DICKSONX'
                     @.3= 'JELLYFISH  SMELLYFISH'
                     @.4= 'DWAYNE     DUANE'
                end                              /* [↑] embedded blanks are shown as is.*/

       do j=1  while @.j\==''                    /*process all the strings in the list. */
       d= jaroD(@.j)
       say 'Jaro distance is  '       format(d, , 8)        " for strings:  "         @.j
       end   /*j*/                               /* └──── digits past the decimal point.*/
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
jaroD: procedure; arg s.1 s.2 .;       L1= length(s.1);      L2= length(s.2);      m= 0
       if L1==0 | L2==0  then return 0           /*check if any string is a null string.*/
       f= max(L1, L2) % 2   -   1                /*calculate furthest distanced allowed.*/
       r.= 0                                     /* [↓]  see if the char is near enough.*/
            do k=1  for L1;   p= pos( substr(s.1, k, 1), s.2,  max(1, k-f) )
            r.k= p
            if p\==0 & abs(p-k)<=f  then m= m+1  /*if near enough, count it as a match. */
                                    else r.k= 0  /*       ··· otherwise, don't count it.*/
            end   /*k*/
       t= 0
            do o=1  for L1;         om= o - 1;       if  r.o==0  |  r.om==0  then iterate
            if pos( substr(s.1, o, 1), s.2)==0  then iterate
            if r.o<r.om  then t= t + 1
            end   /*o*/                          /* [↑]  count number of transpositions.*/

       if m==0  then return 0
                     return (m/L1  +  m/L2  +  (m-t)/m)   /   3
