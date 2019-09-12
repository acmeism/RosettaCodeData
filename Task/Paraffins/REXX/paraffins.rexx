/*REXX program enumerates (without repetition) the # of paraffins with N atoms of carbon*/
parse arg nodes .                                /*obtain optional argument from the CL.*/
if nodes=='' | nodes==","  then nodes= 100       /*Not specified?  Then use the default.*/
  rooted. =  0;     rooted.0= 1;     rooted.1= 1 /*define the  base     rooted  numbers.*/
unrooted. =  0;   unrooted.0= 1;   unrooted.1= 1 /*  "     "     "    unrooted     "    */
numeric digits max(9, nodes % 2)                 /*this program may use gihugeic numbers*/
w= length(nodes)                                 /*W:  used for aligning formatted nodes*/
say  right(0, w)  unrooted.0                     /*show enumerations of  0  carbon atoms*/
                                                 /* [↓]  process all nodes (up to NODES)*/
          do C=1  for nodes;         h= C % 2    /*C:   is the number of carbon atoms.  */
          call  tree  0, C, C, 1, 1              /* [↓]  if # of carbon atoms is even···*/
          if C//2==0  then unrooted.C= unrooted.C   +   rooted.h * (rooted.h + 1) % 2
          say right(C, w)  unrooted.C            /*display an aligned formatted number. */
          end   /*C*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
tree: procedure expose rooted. unrooted. nodes #.          /*this function is recursive.*/
      parse arg br,n,L,sum,cnt;   nm= n - 1;      LL= L + L;               brp= br + 1
               do b=brp  to 4;   sum= sum + n;    if sum>nodes  then leave
               if b==4      then                  if LL>=sum    then leave
               if b==brp    then #.br= rooted.n * cnt
                            else #.br= #.br * (rooted.n + b - brp) % (b - br)
               if LL<sum    then unrooted.sum= unrooted.sum + #.br
               if b==4      then leave
               rooted.sum = rooted.sum + #.br
                  do m=nm  by -1  for nm;   call tree b, m, L, sum, #.br;    end  /*m*/
               end   /*b*/               /* ↑↑↑↑↑↑↑↑↑    recursive invocation of  TREE. */
      return
