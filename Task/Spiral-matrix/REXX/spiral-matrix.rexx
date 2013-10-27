/*REXX program displays a  spiral  in a  square array  (of any size).   */
parse arg size .                       /*get the array size from arg.   */
if size==''  then size=5               /*if no argument, use the default*/
tot=size**2                            /*total # of elements in spiral. */
k=size                                 /*K is the counter for the sprial*/
row=1;   col=0                         /*start with row one,  col zero. */
n=0                                    /*start the spiral at  0  (zero).*/
/*─────────────────────────────────────build the spiral                 */
      do n=0  for k;  col=col+1;  @.col.row=n;  end;    if k==0  then exit

   do  until  n>=tot
   k=k-1
           do n=n  for k;  row=row+1;  @.col.row=n;  end
           do n=n  for k;  col=col-1;  @.col.row=n;  end
  if n>=tot  then leave
  k=k-1
           do n=n  for k;  row=row-1;  @.col.row=n;  end
           do n=n  for k;  col=col+1;  @.col.row=n;  end
   end   /*DO until n≥tot*/
/*─────────────────────────────────────display the spiral               */
   do   col=1  for size;  _=
     do row=1  for size
     _=_ right(@.row.col, length(tot))
     end   /*row*/
  say substr(_,2)
  end      /*col*/
                                       /*stick a fork in it, we're done.*/
