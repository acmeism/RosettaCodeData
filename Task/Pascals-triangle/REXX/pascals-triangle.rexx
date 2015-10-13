/*REXX program displays Pascal's triangle (centered/formatted); also known as:*/
/*────────── Yang Hui's, Khayyam─Pascal, Kyayyam, and/or Tartaglia's triangle.*/
numeric digits 3000                    /*be able to handle gihugeic triangles.*/
parse arg nn .;  if nn==''  then nn=10 /*use default if  NN  wasn't specified.*/
N=abs(nn)                              /*N  is the number of rows in triangle.*/
@.=1;    $.=@.                         /*default value for rows and for lines.*/
w=length(!(N-1) / !(N%2) / !(N-1-N%2)) /*W  is the width of the biggest number*/
                                       /* [↓]  build rows of Pascals' triangle*/
  do   r=1  for N;     rm=r-1          /*Note:  the first column is always  1.*/
    do c=2  to rm;     cm=c-1          /*build the rest of the columns in row.*/
    @.r.c= @.rm.cm + @.rm.c            /*assign value to a specific row & col.*/
    $.r  = $.r     right(@.r.c, w)     /*and construct a line for output (row)*/
    end   /*c*/                        /* [↑]    C  is the column being built.*/
  if r\==1  then $.r=$.r right(1, w)   /*for most rows, append a trailing "1".*/
  end     /*r*/                        /* [↑]    R  is the  row   being built.*/
                                       /* [↑]  WIDTH: for nicely looking line.*/
width=length($.N)                      /*width of the last (output) line (row)*/
                                       /*if NN<0, output is written to a file.*/
        do r=1  for N                  /*show│write lines (rows) of triangle. */
        if nn>0  then say  center($.r, width)                        /*SAY, or*/
                 else call lineout  'PASCALS.'n, center($.r, width)  /*write. */
        end   /*r*/
exit                                   /*stick a fork in it,  we're all done. */
/*──────────────────────────────────! subroutine  (factorial)─────────────────*/
!: procedure;  parse arg x;  !=1;     do j=2  to x;  !=!*j;  end;       return !
