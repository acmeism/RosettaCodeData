/*REXX program demonstrates how to use a  generator  (also known as an  iterator).      */
parse arg N .;   if N=='' |  N==","  then N=20   /*N  not specified?   Then use default.*/
@.=                                              /* [↓]  calculate squares,cubes,pureSq.*/
         do i=1  for N;   call Gsquare     i
                          call Gcube       i
                          call GpureSquare i     /*these are  cube─free  square numbers.*/
         end   /*i*/

     do k=1  for N;  @.pureSquare.k=;  end /*k*/ /*this is used to drop  1st  N  values.*/

w=length(N+10);               ps= 'pure square'  /*the width of the numbers;  a literal.*/

     do m=N+1  for 10;    say ps   right(m, w)":"     right(GpureSquare(m), 3*w)
     end       /*m*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
Gpower:      procedure expose @.;       parse arg x,p;   q=@.pow.x.p
             if q\==''  then return q;  _=x**p;          @.pow.x.p=_
             return _
/*──────────────────────────────────────────────────────────────────────────────────────*/
Gsquare:     procedure expose @.;       parse arg x;     q=@.square.x
             if q==''  then @.square.x=Gpower(x, 2)
             return @.square.x
/*──────────────────────────────────────────────────────────────────────────────────────*/
Gcube:       procedure expose @.;       parse arg x;     q=@.cube.x
             if q==''  then @.cube.x=Gpower(x, 3)        _=@.cube.x;     @.3pow._=1
             return @.cube.x
/*──────────────────────────────────────────────────────────────────────────────────────*/
GpureSquare: procedure expose @.;       parse arg x;     q=@.pureSquare.x
             if q\==''  then return q
             #=0
                   do j=1  until #==x;  ?=Gpower(j, 2)        /*search for pure square. */
                   if @.3pow.?==1  then iterate               /*is it a power of three? */
                   #=#+1;               @.pureSquare.#=?      /*assign next pureSquare. */
                   end   /*j*/
             return @.pureSquare.x
