/*REXX program displays  various alignments  for words in a text string.*/
cols=0;   size=0;   wid.=0;   t.=;   @.=   /*zero|nullify some variables*/
                                           /* [↓]   some "text" lines.  */
t.1 = "Given$a$text$file$of$many$lines,$where$fields$within$a$line$"
t.2 = "are$delineated$by$a$single$'dollar'$character,$write$a$program"
t.3 = "that$aligns$each$column$of$fields$by$ensuring$that$words$in$each$"
t.4 = "column$are$separated$by$at$least$one$space."
t.5 = "Further,$allow$for$each$word$in$a$column$to$be$either$left$"
t.6 = "justified,$right$justified,$or$center$justified$within$its$column."
                                           /* [↑] a null line is the end*/
  do r=1  while  t.r\==''                  /* [↓] process all text lines*/
  _=strip(t.r,,'$')                        /*strip leading & trailing $.*/
                     do c=1  until _==''   /* [↓]  process each word.   */
                     parse  var  _  @.r.c '$' _
                     wid.c=max(wid.c, length(@.r.c))   /*max word width.*/
                     end   /*c*/
  cols=max(cols,c)                         /*use the maximum COLS found.*/
  end    /*r*/

  do k=1  for cols;  size=size+wid.k;  end /*find width of biggest line.*/
rows=r-1                                   /*adjust ROWS because of  DO.*/
  do j=1  for 3;     say;     say          /*show 2 blank lines for sep.*/
  say center(word('left right center', j)  "aligned", size+cols-1, "═")

                do    r=1  for rows;   _=             /*build row by row*/
                   do c=1  for cols;   x=@.r.c        /*  "   col  " col*/
                   if j==1  then _=_   left(x, wid.c) /*justified  left.*/
                   if j==2  then _=_  right(x, wid.c) /*    "     right.*/
                   if j==3  then _=_ centre(x, wid.c) /*    "    center.*/
                   end   /*c*/
                say substr(_,2)        /*ignore the leading extra blank.*/
                end      /*r*/
  end   /*j*/
                                       /*stick a fork in it, we're done.*/
