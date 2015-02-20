/*REXX program creates an  HTML  list of character names  and  remarks. */
charname.  =
charname.1 = "April"
charname.2 = "Tam O'Shanter"
charname.3 = "Emily"
                              do i=1  while  charname.i\==''
                              say 'charname'   i   '='   charname.i
                              end   /*i*/;     say
remark.  =
remark.1 = "I'm > Tam and <= Emily"
remark.2 = "When chapman billies leave the street ..."
remark.3 = "Short & shift"
                              do k=1  while  remark.k\==''
                              say '  remark'   k   '='   remark.k
                              end   /*k*/;     say
items  = 0
header = 'CharacterRemarks'
header = header'>'

    do j=1  while  charname.j\==''
    _=charname.j
    if j==1  then call create '<'header
    call create '    <Character name="' ||,
                char2xml(_)'">"' ||,
                char2xml(remark.j)'"</Character>'
    end   /*j*/

if create.0\==0  then call create '</'header

        do m=1  for create.0
        say create.m                   /*display the  Mth  entry to term*/
        end   /*m*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────CREATE subroutine───────────────────*/
create: items=items+1                  /*bump the count of items in list*/
create.items=arg(1)                    /*add item to the  CREATE  list. */
create.0=items                         /*indicate how many items in list*/
return
/*──────────────────────────────────XML_ subroutine─────────────────────*/
xml_: parse arg _                      /*make an XML entity   (&xxxx;)  */
if pos(_,x)\==0  then return changestr(_,x,"&"arg(2)";")
                      return x
/*──────────────────────────────────CHAR2XML subroutine─────────────────*/
char2xml: procedure;  parse arg x
a=pos('&',x)\==0                       /* &  have to be treated special.*/
b=pos(';',x)\==0                       /* ;    "   "  "    "       "    */
xml0=0
                                       /* [↓]  find a free character ···*/
if a  then do                          /*          ··· translate freely·*/
              do j=0  to 254;   ?=d2c(j);  if pos(?,x)==0  then leave; end
           x=translate(x,?,"&");        xml0=j+1
           end
                                       /* [↓]  find a free character ···*/
if b  then do                          /*          ··· translate freely·*/
              do j=xml0 to 254; ??=d2c(j); if pos(??,x)==0 then leave; end
           x=translate(x,??,";")
           end
                                       /*Following are a few of the     */
                                       /*characters in the DOS (or DOS  */
                                       /*Windows)  codepage   437       */
x=XML_('♥',"hearts")           ; x=XML_('â',"ETH")    ; x=XML_('ƒ',"fnof")  ; x=XML_('═',"boxH")
x=XML_('♦',"diams")            ; x=XML_('â','#x00e2') ; x=XML_('á',"aacute"); x=XML_('╬',"boxVH")
x=XML_('♣',"clubs")            ; x=XML_('â','#x00e9') ; x=XML_('á','#x00e1'); x=XML_('╧',"boxHu")
x=XML_('♠',"spades")           ; x=XML_('ä',"auml")   ; x=XML_('í',"iacute"); x=XML_('╨',"boxhU")
x=XML_('♂',"male")             ; x=XML_('ä','#x00e4') ; x=XML_('í','#x00ed'); x=XML_('╤',"boxHd")
x=XML_('♀',"female")           ; x=XML_('à',"agrave") ; x=XML_('ó',"oacute"); x=XML_('╥',"boxhD")
x=XML_('☼',"#x263c")           ; x=XML_('à','#x00e0') ; x=XML_('ó','#x00f3'); x=XML_('╙',"boxUr")
x=XML_('↕',"UpDownArrow")      ; x=XML_('å',"aring")  ; x=XML_('ú',"uacute"); x=XML_('╘',"boxuR")
x=XML_('¶',"para")             ; x=XML_('å','#x00e5') ; x=XML_('ú','#x00fa'); x=XML_('╒',"boxdR")
x=XML_('§',"sect")             ; x=XML_('ç',"ccedil") ; x=XML_('ñ',"ntilde"); x=XML_('╓',"boxDr")
x=XML_('↑',"uarr")             ; x=XML_('ç','#x00e7') ; x=XML_('ñ','#x00f1'); x=XML_('╫',"boxVh")
x=XML_('↑',"uparrow")          ; x=XML_('ê',"ecirc")  ; x=XML_('Ñ',"Ntilde"); x=XML_('╪',"boxvH")
x=XML_('↑',"ShortUpArrow")     ; x=XML_('ê','#x00ea') ; x=XML_('Ñ','#x00d1'); x=XML_('┘',"boxul")
x=XML_('↓',"darr")             ; x=XML_('ë',"euml")   ; x=XML_('¿',"iquest"); x=XML_('┌',"boxdr")
x=XML_('↓',"downarrow")        ; x=XML_('ë','#x00eb') ; x=XML_('⌐',"bnot")  ; x=XML_('█',"block")
x=XML_('↓',"ShortDownArrow")   ; x=XML_('è',"egrave") ; x=XML_('¬',"not")   ; x=XML_('▄',"lhblk")
x=XML_('←',"larr")             ; x=XML_('è','#x00e8') ; x=XML_('½',"frac12"); x=XML_('▀',"uhblk")
x=XML_('←',"leftarrow")        ; x=XML_('ï',"iuml")   ; x=XML_('½',"half")  ; x=XML_('α',"alpha")
x=XML_('←',"ShortLeftArrow")   ; x=XML_('ï','#x00ef') ; x=XML_('¼',"frac14"); x=XML_('ß',"beta")
x=XML_('1c'x,"rarr")           ; x=XML_('î',"icirc")  ; x=XML_('¡',"iexcl") ; x=XML_('ß',"szlig")
x=XML_('1c'x,"rightarrow")     ; x=XML_('î','#x00ee') ; x=XML_('«',"laqru") ; x=XML_('ß','#x00df')
x=XML_('1c'x,"ShortRightArrow"); x=XML_('ì',"igrave") ; x=XML_('»',"raqru") ; x=XML_('Γ',"Gamma")
x=XML_('!',"excl")             ; x=XML_('ì','#x00ec') ; x=XML_('░',"blk12") ; x=XML_('π',"pi")
x=XML_('"',"apos")             ; x=XML_('Ä',"Auml")   ; x=XML_('▒',"blk14") ; x=XML_('Σ',"Sigma")
x=XML_('$',"dollar")           ; x=XML_('Ä','#x00c4') ; x=XML_('▓',"blk34") ; x=XML_('σ',"sigma")
x=XML_("'","quot")             ; x=XML_('Å',"Aring")  ; x=XML_('│',"boxv")  ; x=XML_('µ',"mu")
x=XML_('*',"ast")              ; x=XML_('Å','#x00c5') ; x=XML_('┤',"boxvl") ; x=XML_('τ',"tau")
x=XML_('/',"sol")              ; x=XML_('É',"Eacute") ; x=XML_('╡',"boxvL") ; x=XML_('Φ',"phi")
x=XML_(':',"colon")            ; x=XML_('É','#x00c9') ; x=XML_('╢',"boxVl") ; x=XML_('Θ',"Theta")
x=XML_('<',"lt")               ; x=XML_('æ',"aelig")  ; x=XML_('╖',"boxDl") ; x=XML_('δ',"delta")
x=XML_('=',"equals")           ; x=XML_('æ','#x00e6') ; x=XML_('╕',"boxdL") ; x=XML_('∞',"infin")
x=XML_('>',"gt")               ; x=XML_('Æ',"AElig")  ; x=XML_('╣',"boxVL") ; x=XML_('φ',"Phi")
x=XML_('?',"quest")            ; x=XML_('Æ','#x00c6') ; x=XML_('║',"boxV")  ; x=XML_('ε',"epsilon")
x=XML_('@',"commat")           ; x=XML_('ô',"ocirc")  ; x=XML_('╗',"boxDL") ; x=XML_('∩',"cap")
x=XML_('[',"lbrack")           ; x=XML_('ô','#x00f4') ; x=XML_('╝',"boxUL") ; x=XML_('≡',"equiv")
x=XML_('\',"bsol")             ; x=XML_('ö',"ouml")   ; x=XML_('╜',"boxUl") ; x=XML_('±',"plusmn")
x=XML_(']',"rbrack")           ; x=XML_('ö','#x00f6') ; x=XML_('╛',"boxuL") ; x=XML_('±',"pm")
x=XML_('^',"Hat")              ; x=XML_('ò',"ograve") ; x=XML_('┐',"boxdl") ; x=XML_('±',"PlusMinus")
x=XML_('`',"grave")            ; x=XML_('ò','#x00f2') ; x=XML_('└',"boxur") ; x=XML_('≥',"ge")
x=XML_('{',"lbrace")           ; x=XML_('û',"ucirc")  ; x=XML_('┴',"bottom"); x=XML_('≤',"le")
x=XML_('{',"lcub")             ; x=XML_('û','#x00fb') ; x=XML_('┴',"boxhu") ; x=XML_('÷',"div")
x=XML_('|',"vert")             ; x=XML_('ù',"ugrave") ; x=XML_('┬',"boxhd") ; x=XML_('÷',"divide")
x=XML_('|',"verbar")           ; x=XML_('ù','#x00f9') ; x=XML_('├',"boxvr") ; x=XML_('≈',"approx")
x=XML_('}',"rbrace")           ; x=XML_('ÿ',"yuml")   ; x=XML_('─',"boxh")  ; x=XML_('∙',"bull")
x=XML_('}',"rcub")             ; x=XML_('ÿ','#x00ff') ; x=XML_('┼',"boxvh") ; x=XML_('°',"deg")
x=XML_('Ç',"Ccedil")           ; x=XML_('Ö',"Ouml")   ; x=XML_('╞',"boxvR") ; x=XML_('·',"middot")
x=XML_('Ç','#x00c7')           ; x=XML_('Ö','#x00d6') ; x=XML_('╟',"boxVr") ; x=XML_('·',"middledot")
x=XML_('ü',"uuml")             ; x=XML_('Ü',"Uuml")   ; x=XML_('╚',"boxUR") ; x=XML_('·',"centerdot")
x=XML_('ü','#x00fc')           ; x=XML_('Ü','#x00dc') ; x=XML_('╔',"boxDR") ; x=XML_('·',"CenterDot")
x=XML_('é',"eacute")           ; x=XML_('¢',"cent")   ; x=XML_('╩',"boxHU") ; x=XML_('√',"radic")
x=XML_('é','#x00e9')           ; x=XML_('£',"pound")  ; x=XML_('╦',"boxHD") ; x=XML_('²',"sup2")
x=XML_('â',"acirc")            ; x=XML_('¥',"yen")    ; x=XML_('╠',"boxVR") ; x=XML_('■',"squart ")

if a  then x=xml_(?,"amp")     /*if there was an ampersand, translate it*/
if b  then x=xml_(??,"semi")   /* "   "    "   " semicolon,     "      "*/
return x
