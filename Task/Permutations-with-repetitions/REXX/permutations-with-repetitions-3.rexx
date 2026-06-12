/*REXX pgm gens all permutations with repeats of  N  objects (<10) taken  M  at a time. */
parse arg N M .
z= N**M
$= left(1234567890, N)
t= 0
          do j=copies(1, M)  until t==z
          if verify(j, $)\==0  then iterate
          t= t+1
          say j
          end   /*j*/                            /*stick a fork in it,  we're all done. */
