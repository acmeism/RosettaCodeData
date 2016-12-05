/*REXX program solves the  "Twelve Statement Puzzle".                                   */
q=12;      @stmt=right('statement',20)           /*number of statements in the puzzle.  */
m=0                                              /*[↓]  statement one is  TRUE  by fiat.*/
      do pass=1  for 2                           /*find the maximum number of  "trues". */
        do e=0   for 2**(q-1);    n = '1'right( x2b( d2x( e ) ),  q-1,  0)
              do b=1  for q                      /*define various bits in the number  Q.*/
              @.b=substr(n, b, 1)                /*define a particular  @  bit  (in  Q).*/
              end   /*b*/
        if @.1  then   if \ @.1                             then iterate
        if @.2  then   if @.7+@.8+@.9+@.10+@.11+@.12  \==3  then iterate
        if @.3  then   if @.2+@.4+@.6+@.8+@.10+@.12   \==2  then iterate
        if @.4  then   if @.5  then if \(@.6 & @.7)         then iterate
        if @.5  then   if @.2  |  @.3  |  @.4               then iterate
        if @.6  then   if @.1+@.3+@.5+@.7+@.9+@.11    \==4  then iterate
        if @.7  then   if \ (@.2  &&  @.3 )                 then iterate
        if @.8  then   if @.7  then  if \(@.5 & @.6)        then iterate
        if @.9  then   if @.1+@.2+@.3+@.4+@.5+@.6     \==3  then iterate
        if @.10 then   if \ (@.11 & @.12)                   then iterate
        if @.11 then   if @.7+@.8+@.9                 \==1  then iterate
                          g=@.1 +@.2 +@.3 +@.4 +@.5 +@.6 +@.7 +@.8+ @.9 +@.10 +@.11
        if @.12 then   if g                           \==4  then iterate
        g=g + @.12
        if pass==1  then do;  m=max(m,g);  iterate;  end
                    else if g\==m     then iterate
            do j=1  for q;  z=substr(n, j, 1)
            if z  then  say @stmt right(j, 2)        " is "        word('false true', 1+z)
            end   /*tell*/
        end       /*e*/
      end         /*pass*/                       /*stick a fork in it,  we're all done. */
