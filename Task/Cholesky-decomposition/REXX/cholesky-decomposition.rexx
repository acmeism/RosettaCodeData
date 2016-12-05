/*REXX program performs the  Cholesky  decomposition  on a square matrix.     */
niner =  '25  15  -5' ,                              /*define a  3x3  matrix. */
         '15  18   0' ,
         '-5   0  11'
                           call Cholesky niner
hexer =  18  22  54  42,                             /*define a  4x4  matrix. */
         22  70  86  62,
         54  86 174 134,
         42  62 134 106
                           call Cholesky hexer
exit                                   /*stick a fork in it,  we're all done. */
/*────────────────────────────────────────────────────────────────────────────*/
Cholesky: procedure;  parse arg mat;   say;   say;   call tell 'input matrix',mat
             do    r=1  for ord
                do c=1  for r; $=0;  do i=1  for c-1; $=$+!.r.i*!.c.i; end /*i*/
                if r=c  then !.r.r=sqrt(!.r.r-$)
                        else !.r.c=1/!.c.c*(@.r.c-$)
                end   /*c*/
             end      /*r*/
          call tell  'Cholesky factor',,!.,'─'
          return
/*────────────────────────────────────────────────────────────────────────────*/
err:   say;  say;  say '***error***!';    say;  say arg(1);  say;  say;  exit 13
/*────────────────────────────────────────────────────────────────────────────*/
tell:  parse arg hdr,x,y,sep;   #=0;             if sep==''  then sep='═'
       dPlaces= 5                    /*# decimal places past the decimal point*/
       width  =10                    /*width of field used to display elements*/
       if y==''  then !.=0
                 else do row=1  for ord; do col=1  for ord; x=x !.row.col; end; end
       w=words(x)
           do ord=1  until ord**2>=w; end  /*a fast way to find matrix's order*/
       say
       if ord**2\==w  then call err  "matrix elements don't form a square matrix."
       say center(hdr, ((width+1)*w)%ord, sep)
       say
               do   row=1  for ord;       z=
                 do col=1  for ord;       #=#+1
                                    @.row.col=word(x,#)
                 if col<=row  then  !.row.col=@.row.col
                 z=z  right( format(@.row.col,, dPlaces) / 1,   width)
                 end   /*col*/
               say z
               end        /*row*/
       return
/*────────────────────────────────────────────────────────────────────────────*/
sqrt:  procedure; parse arg x;   if x=0  then return 0;  d=digits();  i=;   m.=9
       numeric digits 9; numeric form; h=d+6; if x<0  then  do; x=-x; i='i'; end
       parse value format(x,2,1,,0) 'E0'  with  g 'E' _ .;       g=g*.5'e'_%2
          do j=0  while h>9;      m.j=h;              h=h%2+1;        end  /*j*/
          do k=j+5  to 0  by -1;  numeric digits m.k; g=(g+x/g)*.5;   end  /*k*/
       numeric digits d;     return (g/1)i            /*make complex if X < 0.*/
