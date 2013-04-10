/*REXX program to display various alignments. */
cols=0;    size=0;     wid.=0;     t.=;     @.=

t.1 = "Given$a$text$file$of$many$lines,$where$fields$within$a$line$"
t.2 = "are$delineated$by$a$single$'dollar'$character,$write$a$program"
t.3 = "that$aligns$each$column$of$fields$by$ensuring$that$words$in$each$"
t.4 = "column$are$separated$by$at$least$one$space."
t.5 = "Further,$allow$for$each$word$in$a$column$to$be$either$left$"
t.6 = "justified,$right$justified,$or$center$justified$within$its$column."

  do r=1 while t.r\==''
  _=strip(t.r,,'$')
                       do c=1 until _==''
                       parse var _ @.r.c '$' _
                       wid.c=max(wid.c,length(@.r.c))
                       end   /*c*/
  cols=max(cols,c)
  end    /*r*/

rows=r-1                                   /*adjust ROWS, it's 1 too big*/
  do k=1 for cols;  size=size+wid.k;  end  /*find width of biggest line.*/

  do j=1 for 3;  say
  say center(word('left right center',j) "aligned",size+cols-1,"=")

                 do r=1 for rows;   _=
                       do c=1 for cols;  x=@.r.c
                       if j==1 then _=_   left(x,wid.c)
                       if j==2 then _=_  right(x,wid.c)
                       if j==3 then _=_ centre(x,wid.c)
                       end    /*c*/
                 say substr(_,2)
                 end          /*r*/
  say
  end   /*j*/
