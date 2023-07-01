\ Color Bars for TI-99 CAMEL99 Forth

NEEDS HCHAR   FROM DSK1.GRAFIX    \ TMS9918 control lexicon
NEEDS CHARSET FROM DSK1.CHARSET   \ restores default character data
NEEDS ENUM    FROM DSK1.ENUM      \ add simple enumerator to Forth

\ Name TI-99 colors
1 ENUM CLR     ENUM BLK    ENUM MGRN   ENUM LGRN
  ENUM BLU     ENUM LBLU   ENUM RED    ENUM CYAN
  ENUM MRED    ENUM LRED   ENUM YEL    ENUM LYEL
  ENUM GRN     ENUM MAG    ENUM GRY    ENUM WHT
DROP

\ square character data
HEX
CREATE SQUARE  FFFF , FFFF , FFFF , FFFF ,

DECIMAL
: COLOR-BARS ( -- )
   24 0 DO
\   col row char wid
\   --- --- ---- ---
      2  I   88   4 HCHAR
      6  I   96   4 HCHAR
     10  I  104   4 HCHAR
     14  I  112   4 HCHAR
     18  I  120   4 HCHAR
     22  I  128   4 HCHAR
     26  I  136   4 HCHAR
   LOOP ;

DECIMAL
: DEFCHARS ( pattern first last -- )
        1+ SWAP ?DO   DUP I CHARDEF  8 +LOOP DROP ;

: SET-COLORS ( -- )
\   charset  fg   bg
\   -------  --   --
    88 SET#  GRY  CLR COLOR
    96 SET#  YEL  CLR COLOR
   104 SET#  CYAN CLR COLOR
   112 SET#  GRN  CLR COLOR
   120 SET#  MAG  CLR COLOR
   128 SET#  RED  CLR COLOR
   136 SET#  BLU  CLR COLOR
   144 SET#  BLK  CLR COLOR ;

\ restore characters and colors
: DEFAULTS
   8 SCREEN
   4 19 BLK CLR COLORS
   CLEAR
   CHARSET ;

: BARS
   CLEAR  BLK SCREEN
   SET-COLORS
   SQUARE 88 152 DEFCHARS
   COLOR-BARS
   BEGIN ?TERMINAL  UNTIL
   DEFAULTS
;

CR .( Done. Type BARS to run)
