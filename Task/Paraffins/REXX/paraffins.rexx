/*REXX program to enumerate number #  paraffins  for  N atoms of carbon.*/
parse arg nodes .; if nodes=='' then nodes=100  /*Not given? Use default*/
  rooted. =  0;      rooted.0=1;     rooted.1=1 /*define base rooted #s.*/
unrooted. =  0;    unrooted.0=1;   unrooted.1=1 /*  "      " unrooted " */
numeric digits max(9,nodes%2)                   /*may use gi-hugeic nums*/
w=length(nodes)                                 /*for formatted display.*/
say right(0,w) unrooted.0                       /*··· zero carbon atoms.*/
                                                /* [↓]  process nodes.  */
          do C=1  for nodes;         h=C%2      /*C:  # of carbon atoms.*/
          call  tree  0, C, C, 1, 1             /* [↓]  if  C  is even. */
          if C//2==0  then unrooted.C=unrooted.C + rooted.h*(rooted.h+1)%2
          say right(C,w)  unrooted.C            /*display formatted #'s.*/
          end   /*C*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────TREE subroutine─────────────────────*/
tree: procedure expose rooted. unrooted. nodes #.           /*recursive.*/
parse arg br,n,L,sum,cnt;  nm=n-1;     LL=L+L;       brp=br+1
         do b=brp  to 4;   sum=sum+n;  if sum>nodes  then leave
         if b==4      then             if LL>=sum    then leave
         if b==brp    then #.br=rooted.n*cnt
                      else #.br=#.br*(rooted.n+b-brp)%(b-br)
         if LL<sum    then unrooted.sum=unrooted.sum+#.br
         if b==4      then leave
         rooted.sum = rooted.sum+#.br
            do m=nm  by -1 for nm;   call tree b,m,L,sum,#.br;   end /*m*/
         end   /*b*/
return
