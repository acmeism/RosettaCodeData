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
  say center(word('left right center', j)  "aligned", size+cols+1, "═")

                 do r=0  to rows;   _=;   !='│';   if r==0 then !='┬'
                       do c=1  for cols;   x=@.r.c
                       if r==0  then x=copies("─",wid.c+1)
                       if j==1  then _=_ || ! ||   left(x,wid.c)
                       if j==2  then _=_ || ! ||  right(x,wid.c)
                       if j==3  then _=_ || ! || centre(x,wid.c)
                       end   /*c*/
                 if r==0 then do;    _= '┌'substr(_,2,length(_)-1)"┐"
                                   bot= '└'substr(_,2,length(_)-2)"┘"
                              end
                         else _=_ || !
                 say _
                 end         /*r*/
                                           /* [↑]  shows words in boxes.*/
  say translate(bot,'┴',"┬")
  end   /*j*/
