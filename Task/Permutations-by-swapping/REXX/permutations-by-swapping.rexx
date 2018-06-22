/*REXX program  generates all  permutations  of   N   different objects by  swapping.   */
parse arg things bunch .                         /*obtain optional arguments from the CL*/
if things=='' | things==","  then things=4       /*Not specified?  Then use the default.*/
if bunch =='' | bunch ==","  then bunch =things  /* "      "         "   "   "     "    */
call permSets things, bunch                      /*invoke permutations by swapping sub. */
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
!:        procedure;  !=1;        do j=2  to arg(1);    !=!*j;     end;           return !
/*──────────────────────────────────────────────────────────────────────────────────────*/
permSets: procedure; parse arg x,y               /*take   X  things   Y   at a time.    */
          !.=0;      pad=left('', x*y)           /*X can't be > length of below str (62)*/
          z=left('123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ', x);  q=z
          #=1                                    /*the number of permutations  (so far).*/
          !.z=1;    s=1;   times=!(x) % !(x-y)   /*calculate (#) TIMES  using factorial.*/
          w=max(length(z), length('permute') )   /*maximum width of  Z and also PERMUTE.*/
          say center('permutations for '   x   ' things taken '   y   " at a time",60,'═')
          say
          say   pad    'permutation'       center("permute", w, '─')         "sign"
          say   pad    '───────────'       center("───────", w, '─')         "────"
          say   pad    center(#, 11)       center(z        , w)              right(s, 4-1)

             do $=1   until  #==times            /*perform permutation until # of times.*/
               do   k=1    for x-1               /*step thru things for  things-1 times.*/
                 do m=k+1  to  x;      ?=        /*this method doesn't use  adjacency.  */
                     do n=1  for x               /*build the new permutation by swapping*/
                     if n\==k & n\==m  then               ? =  ?  ||  substr(z, n, 1)
                                       else if n==k  then ? =  ?  ||  substr(z, m, 1)
                                                     else ? =  ?  ||  substr(z, k, 1)
                     end   /*n*/
                 z=?                             /*save this permutation for next swap. */
                 if !.?  then iterate m          /*if defined before, then try next one.*/
                 _=0                             /* [↓]  count number of swapped symbols*/
                    do d=1  for x  while $\==1;  _= _ + (substr(?,d,1)\==substr(prev,d,1))
                    end   /*d*/
                 if _>2  then do;        _=z
                              a=$//x+1;  q=q + _ /* [← ↓]  this swapping tries adjacency*/
                              b=q//x+1;  if b==a  then b=a + 1;       if b>x  then b=a - 1
                              z=overlay( substr(z,b,1), overlay( substr(z,a,1), _, b),  a)
                              iterate $          /*now, try this particular permutation.*/
                              end
                 #=#+1;  s= -s;   say pad   center(#, 11)    center(?, w)    right(s, 4-1)
                 !.?=1;  prev=?;      iterate $  /*now, try another swapped permutation.*/
                 end   /*m*/
               end     /*k*/
             end       /*$*/
          return                                 /*we're all finished with permutating. */
