/*REXX program to display various alignments.                           */
cols=0;   parse var cols size 1 wid. t.               /*initializations.*/

t.1 = "Given$a$text$file$of$many$lines,$where$fields$within$a$line$"
t.2 = "are$delineated$by$a$single$'dollar'$character,$write$a$program"
t.3 = "that$aligns$each$column$of$fields$by$ensuring$that$words$in$each$"
t.4 = "column$are$separated$by$at$least$one$space."
t.5 = "Further,$allow$for$each$word$in$a$column$to$be$either$left$"
t.6 = "justified,$right$justified,$or$center$justified$within$its$column."

  do r=1 while t.r\==''
  t.r=translate(t.r,,'$')
                           do c=1 until word(t.r,c)==''
                           wid.c=max(wid.c,length(word(t.r,c)))
                           end   /*c*/
  cols=max(cols,c)
  end   /*r*/

rows=r-1                                   /*adjust ROWS, it's 1 too big*/

  do k=1 for cols;  size=size+wid.k;  end  /*find width of biggest line.*/

  do j=1 for 3;   say
  say center(word('left right center',j) "aligned",size+cols,"=");   say

                 do r=0 to rows;   _=;   !='│';   if r==0 then !='┬'

                       do c=1 for cols;   x=word(t.r,c)
                       if r==0 then x=copies("─",wid.c+1)
                               else x=word(t.r,c)
                       if j==1 then _=_ || ! ||   left(x,wid.c)
                       if j==2 then _=_ || ! ||  right(x,wid.c)
                       if j==3 then _=_ || ! || centre(x,wid.c)
                       end   /*c*/

                 if r==0 then do;   _='┌'substr(_,2,length(_)-2)"┐"
                                  bot='└'substr(_,2,length(_)-2)"┘"
                              end
                 say _
                 end         /*r*/

  say translate(bot,'┴',"┬"); say; say
  end   /*j*/
