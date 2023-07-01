/*REXX program constructs a  magic square  of doubly even sides (a size divisible by 4).*/
n= 8;   s= n%4;   L= n%2-s+1;    w= length(n**2) /*size; small sq;  low middle;  # width*/
@.= 0;            H= n%2+s                       /*array default;  high middle.         */
call gen                                         /*generate a grid in numerical order.  */
call diag                                        /*mark numbers on both diagonals.      */
call corn                                        /*  "     "    in small corner boxen.  */
call midd                                        /*  "     "    in  the middle    "     */
call swap                                        /*swap positive numbers with highest #.*/
call show                                        /*display the doubly even magic square.*/
call sum                                         /*   "     "  magic number for square. */
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
o:    parse arg ?;             return n-?+1      /*calculate the "other" (right) column.*/
@:    parse arg x,y;           return abs(@.x.y)
diag:      do r=1 for n;  @.r.r=-@(r,r); o=o(r);  @.r.o=-@(r,o);  end;              return
midd:      do r=L  to H;  do c=L  to H;  @.r.c=-@(r,c);           end;  end;        return
gen:  #=0; do r=1 for n;  do c=1  for n; #=#+1;   @.r.c=#;        end;  end;        return
show: #=0; do r=1 for n;  $=; do c=1  for n; $=$ right(@(r,c),w); end;  say $; end; return
sum:  #=0; do r=1 for n;  #=#+@(r,1);  end;  say;  say 'The magic number is: '   #; return
max#:      do a=n for n  by -1;  do b=n  for n  by -1;  if @.a.b>0  then return; end;  end
/*──────────────────────────────────────────────────────────────────────────────────────*/
swap:         do   r=1  for n
                do c=1  for n;  if @.r.c<0  then iterate;  call max#  /*find max number.*/
                parse value  -@.a.b  (-@.r.c)    with    @.r.c  @.a.b /*swap two values.*/
                end   /*c*/
              end     /*r*/;                       return
/*──────────────────────────────────────────────────────────────────────────────────────*/
corn:         do   r=1  for n;  if r>s & r<=n-s  then iterate   /*"corner boxen", size≡S*/
                do c=1  for n;  if c>s & c<=n-s  then iterate;  @.r.c= -@(r,c)  /*negate*/
                end   /*c*/
              end     /*r*/;                       return
