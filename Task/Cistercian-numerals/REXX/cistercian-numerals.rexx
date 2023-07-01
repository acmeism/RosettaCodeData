/*REXX program displays a (non-negative 4-digit) integer in  Cistercian (monk) numerals.*/
parse arg m                                      /*obtain optional arguments from the CL*/
if m='' | m=","  then m= 0 1 20 300 4000 5555 6789 9393  /*Not specified?  Use defaults.*/
$.=;                     nnn= words(m)
             do j=1  for nnn;   z= word(m, j)            /*process each of the numbers. */
             if \datatype(z, 'W')  then call serr  "number isn't numeric: "           z
             if \datatype(z, 'N')  then call serr  "number isn't an integer: "        z
             z= z / 1                            /*normalize the number:  006  5.0  +4  */
             if z<0                then call serr  "number can't be negative: "       z
             if z>9999             then call serr  "number is too large (>9,999): "   z
             call monk z / 1                     /*create the Cistercian quad numeral.  */
             end   /*j*/
call show                                        /*display   "      "       "     "     */
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
@:    parse arg @x,@y;  return @.@x.@y           /*return a value from the point (@x,@y)*/
quad: parse arg #;   if #\==0  then interpret 'call' #;  return       /*build a numeral.*/
serr: say '***error*** '  arg(1);    exit 13                          /*issue error msg.*/
app:   do r= 9 for 10 by -1; do c=-5 for 11; $.r= $.r||@.c.r; end; $.r=$.r b5; end; return
eye:   do a=0  for 10; @.0.a= '│';   end; return /*build an "eye" glyph (vertical axis).*/
p:     do k=1  by 3  until k>arg(); x= arg(k); y= arg(k+1); @.x.y= arg(k+2); end;   return
sect:  do q=1  for 4; call quad s.q; end; return /*build a Cistercian numeral character.*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
monk: parse arg n; n= right(n, 4, 0);  @.= ' '   /*zero─fill N;  blank─out numeral grid.*/
      b4= left('', 4);  b5= b4" ";   $.11= $.11  ||  b4  ||  n  ||  b4  ||  b5;   call eye
      parse var n s.4 2 s.3 3 s.2 4 s.1;    call sect;    call nice;    call app;   return
/*──────────────────────────────────────────────────────────────────────────────────────*/
nice: if @(-1, 9)=='─'     then call p 0, 9, "┐";    if @(1,9)=='─'  then call p 0, 9, "┌"
      if @(-1, 9)=='─'  &  @(1,9)=='─'                               then call p 0, 9, "┬"
      if @(-1, 0)=='─'     then call p 0, 0, "┘";    if @(1,0)=='─'  then call p 0, 0, "└"
      if @(-1, 0)=='─'  &  @(1,0)=='─'                               then call p 0, 0, "┴"
         do i=4  to 5
         if @(-1, i)=='─'  then call p 0, i, "┤";    if @(1,i)=='─'  then call p 0, i, "├"
         if @(-1, i)=='─'  &  @(1,i)=="─"                            then call p 0, i, "┼"
         end   /*i*/;                                                               return
/*──────────────────────────────────────────────────────────────────────────────────────*/
show:    do jj= 11  for 10+2  by -1;    say strip($.jj, 'T')  /*display 1 row at a time.*/
         if jj==5  then do 3;           say strip( copies(b5'│'b5 b5, nnn), 'T');     end
         end   /*r*/;                   return
/*──────────────────────────────────────────────────────────────────────────────────────*/
1: ?= '─';  if q==1  then call p  1, 9, ?,  2, 9, ?,  3, 9, ?,  4, 9, ?,  5, 9, ?
            if q==2  then call p -1, 9, ?, -2, 9, ?, -3, 9, ?, -4, 9, ?, -5, 9, ?
            if q==3  then call p  1, 0, ?,  2, 0, ?,  3, 0, ?,  4, 0, ?,  5, 0, ?
            if q==4  then call p -1, 0, ?, -2, 0, ?, -3, 0, ?, -4, 0, ?, -5, 0, ?;  return
/*──────────────────────────────────────────────────────────────────────────────────────*/
2: ?= '─';  if q==1  then call p  1, 5, ?,  2, 5, ?,  3, 5, ?,  4, 5, ?,  5, 5, ?
            if q==2  then call p -1, 5, ?, -2, 5, ?, -3, 5, ?, -4, 5, ?, -5, 5, ?
            if q==3  then call p  1, 4, ?,  2, 4, ?,  3, 4, ?,  4, 4, ?,  5, 4, ?
            if q==4  then call p -1, 4, ?, -2, 4, ?, -3, 4, ?, -4, 4, ?, -5, 4, ?;  return
/*──────────────────────────────────────────────────────────────────────────────────────*/
3: ?= '\';  if q==1  then call p  1, 9, ?,  2, 8, ?,  3, 7, ?,  4, 6, ?,  5, 5, ?
   ?= '/';  if q==2  then call p -1, 9, ?, -2, 8, ?, -3, 7, ?, -4, 6, ?, -5, 5, ?
   ?= '/';  if q==3  then call p  1, 0, ?,  2, 1, ?,  3, 2, ?,  4, 3, ?,  5, 4, ?
   ?= '\';  if q==4  then call p -5, 4, ?, -4, 3, ?, -3, 2, ?, -2, 1, ?, -1, 0, ?;  return
/*──────────────────────────────────────────────────────────────────────────────────────*/
4: ?= '/';  if q==1  then call p  1, 5, ?,  2, 6, ?,  3, 7, ?,  4, 8, ?,  5, 9, ?
   ?= '\';  if q==2  then call p -5, 9, ?, -4, 8, ?, -3, 7, ?, -2, 6, ?, -1, 5, ?
   ?= '\';  if q==3  then call p  1, 4, ?,  2, 3, ?,  3, 2, ?,  4, 1, ?,  5, 0, ?
   ?= '/';  if q==4  then call p -5, 0, ?, -4, 1, ?, -3, 2, ?, -2, 3, ?, -1, 4, ?;  return
/*──────────────────────────────────────────────────────────────────────────────────────*/
5: ?= '/';  if q==1  then call p  1, 5, ?,  2, 6, ?,  3, 7, ?,  4, 8, ?
   ?= '\';  if q==2  then call p -4, 8, ?, -3, 7, ?, -2, 6, ?, -1, 5, ?
   ?= '\';  if q==3  then call p  1, 4, ?,  2, 3, ?,  3, 2, ?,  4, 1, ?
   ?= '/';  if q==4  then call p -4, 1, ?, -3, 2, ?, -2, 3, ?, -1, 4, ?;  call 1;   return
/*──────────────────────────────────────────────────────────────────────────────────────*/
6: ?= '│';  if q==1  then call p  5, 9, ?,  5, 8, ?,  5, 7, ?,  5, 6, ?,  5, 5, ?
            if q==2  then call p -5, 9, ?, -5, 8, ?, -5, 7, ?, -5, 6, ?, -5, 5, ?
            if q==3  then call p  5, 0, ?,  5, 1, ?,  5, 2, ?,  5, 3, ?,  5, 4, ?
            if q==4  then call p -5, 0, ?, -5, 1, ?, -5, 2, ?, -5, 3, ?, -5, 4, ?;  return
/*──────────────────────────────────────────────────────────────────────────────────────*/
7:          call 1;  call 6;         if q==1  then call p  5, 9, '┐'
                                     if q==2  then call p -5, 9, '┌'
                                     if q==3  then call p  5, 0, '┘'
                                     if q==4  then call p -5, 0, '└';               return
/*──────────────────────────────────────────────────────────────────────────────────────*/
8:          call 2;  call 6;         if q==1  then call p  5, 5, '┘'
                                     if q==2  then call p -5, 5, '└'
                                     if q==3  then call p  5, 4, '┐'
                                     if q==4  then call p -5, 4, '┌';               return
/*──────────────────────────────────────────────────────────────────────────────────────*/
9:          call 1; call 2; call 6;  if q==1  then call p  5, 5, '┘',  5, 9, "┐"
                                     if q==2  then call p -5, 5, '└', -5, 9, "┌"
                                     if q==3  then call p  5, 0, '┘',  5, 4, "┐"
                                     if q==4  then call p -5, 0, '└', -5, 4, "┌";   return
