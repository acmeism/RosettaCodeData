/*REXX program solves the  "Twelve Statement Puzzle".                   */
q=12;      @stmt=right('statement',20) /*number of statements in puzzle.*/
m=0                                    /*[↓] statement 1 is TRUE by fiat*/
      do pass=1  for 2                 /*find the maximum number trues. */
        do e=0   for 2**(q-1);         n = '1'right(x2b(d2x(e)), q-1, 0)
              do b=1  for q            /*define the various bits.       */
              @.b=substr(n,b,1)        /*define a particular  @  bit.   */
              end   /*b*/
        if @.1  then if yeses(1,1)                      \==1  then iterate
        if @.2  then if yeses(7,12)                     \==3  then iterate
        if @.3  then if yeses(2,12,2)                   \==2  then iterate
        if @.4  then if yeses(5,5)  then  if yeses(6,7) \==2  then iterate
        if @.5  then if yeses(2,4)                      \==0  then iterate
        if @.6  then if yeses(1,12,2)                   \==4  then iterate
        if @.7  then if yeses(2,3)                      \==1  then iterate
        if @.8  then if yeses(7,7)  then  if yeses(5,6) \==2  then iterate
        if @.9  then if yeses(1,6)                      \==3  then iterate
        if @.10 then if yeses(11,12)                    \==2  then iterate
        if @.11 then if yeses(7,9)                      \==1  then iterate
        if @.12 then if yeses(1,11)                     \==4  then iterate
        _=yeses(1,12)
        if pass==1  then do;   m=max(m,_);   iterate;   end
                    else if _\==m       then iterate
            do j=1  for q;    _=substr(n,j,1)
            if _  then  say @stmt right(j,2) " is " word('false true',1+_)
            end   /*tell*/
        end       /*e*/
      end         /*pass*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────YESES subroutine────────────────────*/
yeses: parse arg L,H,B; #=0;    do i=L  to H  by word(B 1,1); #=#+@.i; end
       return #
