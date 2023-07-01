/*REXX program displays an  ASCII  table of characters  (within a  16x16  indexed grid).*/
parse upper version !ver .                       /*some REXXes can't display '1b'x glyph*/
!pcRexx= 'REXX/PERSONAL'==!ver | "REXX/PC"==!ver /*is this  PC/REXX  or  REXX/Personal? */
          func= '  nul soh stx etx eot enq ack bel  bs tab  lf  vt  ff  cr  so  si  '  ||,
                "  dle dc1 dc2 dc3 dc4 nak syn etb can  em eof esc  fs  gs  rs  us  "
@.=
@.1= "x'07'    x'08'       x'09'     x'0a'      x'0d'      x'1a'      x'1b'     x'20'"
@.2= "bel      b/s         tab       l/f        c/r        eof        esc       bla"
@.3= "bell     backspace   tabchar   linefeed   carriage   end-of-    escape    blank"
@.4= "                                          return     file"
@.5= copies('≈', 79)
            do a=1  for 8;   say @.a             /*display header info  (abbreviations).*/
            end   /*a*/                          /*also included are three blank lines. */
b= ' ';         hdr= left(b, 7)                  /*prepend blanks to HDR  (indentation).*/
call xhdr                                        /*construct a  top  index for the grid.*/
call grid '╔',  "╤",  '╗',  "═══"                /*construct & display bottom of a cell.*/
iidx= left(b, length(hdr) - 4 )                  /*the length of the indentation of idx.*/
cant= copies('═', 3)                             /*can't show a character with this REXX*/
                                                 /* [↓]  construct a sixteen-row grid.  */
   do j=0  by 16  for 16;  idx= left(d2x(j),1,2) /*prepend an index literal for the grid*/
   _= iidx idx b;           _h= iidx "   "       /*an index and indent; without an index*/
   sep= '║'                                      /*assign a character to cell separator.*/
             do #=j  to j+15;               chr= center( d2c(#), 3)   /*true char glyph.*/
             if #>6 & #<11  |  #==13   then chr= cant         /*can't show these glyphs.*/
   /*esc*/   if #==27 then if !pcRexx  then chr= cant         /*  "     "  this  glyph. */
                                       else chr= center( d2c(#), 3)   /*true char glyph.*/
             if # <32 then _h= _h || sep || right(word(func, #+1), 3) /*show a function.*/
             if #==32 then chr= 'bla'            /*spell out (within 3 chars) a "BLAnk".*/
             if # >31 then _h=                   /*Above a blank?  Then nullify 3rd line*/
             _= _ || sep || chr;     sep= '│'    /*append grid cell; use a new sep char.*/
             end   /*#*/
   if _h\==''  then say _h"║ "                   /*append the  last grid cell character.*/
   say _'║ '   idx                               /*append an   index   to the grid line.*/
   if j\==240  then call grid '╟',"┼",'╢',"───"  /*construct & display most cell bottoms*/
   end   /*j*/

call grid '╚',  "╧",  '╝',  "═══"                /*construct & display last cell bottom.*/
call xhdr                                        /*construct a bottom index for the grid*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
xhdr: say; _= hdr;  sep= b;   do k=0  for 16; _=_||b d2x(k)b;  end;    say _; say;  return
grid: arg $1,$2,$3,$4; _=hdr; do 16;  _=_ || $1 || $4;  $1= $2;  end;  say _ || $3; return
