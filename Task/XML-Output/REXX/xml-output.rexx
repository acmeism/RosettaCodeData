/*REXX program creates an HTML (XML) list of character names and corresponding remarks. */
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
    call create '    <Character name="'  ||,
                char2xml(_)'">"'         ||,
                char2xml(remark.j)'"</Character>'
    end   /*j*/

if create.0\==0  then call create '</'header

        do m=1  for create.0
        say create.m                             /*display the  Mth  entry to terminal. */
        end   /*m*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
char2xml: procedure;  parse arg $
          amper = pos('&', $)\==0                /*  &   has to be treated special.     */
          semi  = pos(';', $)\==0                /*  ;    "   "  "    "       "         */
          #=0                                    /* [↓]  find a free/unused character···*/
          if amper  then do                      /*          ··· and translate freely.  */
                           do j=0  for 255;    ?=d2c(j);    if pos(?, $)==0   then leave
                           end   /*j*/
                         $=translate($, ?, "&");            #= j + 1
                         end
                                                 /* [↓]  find a free/unused character···*/
          if semi   then do                      /*          ··· and translate freely.  */
                           do k=#  for 255;    ?=d2c(k);    if pos(?, $)==0  then leave
                           end   /*k*/
                         $=translate($, ?, ";")
                         end

/*───── Following are most of the characters in the  DOS  (or DOS Windows)  codepage  437 ──────────*/

$=XML_('â',"ETH")    ; $=XML_('ƒ',"fnof")  ; $=XML_('═',"boxH")      ; $=XML_('♥',"hearts")
$=XML_('â','#x00e2') ; $=XML_('á',"aacute"); $=XML_('╬',"boxVH")     ; $=XML_('♦',"diams")
$=XML_('â','#x00e9') ; $=XML_('á','#x00e1'); $=XML_('╧',"boxHu")     ; $=XML_('♣',"clubs")
$=XML_('ä',"auml")   ; $=XML_('í',"iacute"); $=XML_('╨',"boxhU")     ; $=XML_('♠',"spades")
$=XML_('ä','#x00e4') ; $=XML_('í','#x00ed'); $=XML_('╤',"boxHd")     ; $=XML_('♂',"male")
$=XML_('à',"agrave") ; $=XML_('ó',"oacute"); $=XML_('╥',"boxhD")     ; $=XML_('♀',"female")
$=XML_('à','#x00e0') ; $=XML_('ó','#x00f3'); $=XML_('╙',"boxUr")     ; $=XML_('☼',"#x263c")
$=XML_('å',"aring")  ; $=XML_('ú',"uacute"); $=XML_('╘',"boxuR")     ; $=XML_('↕',"UpDownArrow")
$=XML_('å','#x00e5') ; $=XML_('ú','#x00fa'); $=XML_('╒',"boxdR")     ; $=XML_('¶',"para")
$=XML_('ç',"ccedil") ; $=XML_('ñ',"ntilde"); $=XML_('╓',"boxDr")     ; $=XML_('§',"sect")
$=XML_('ç','#x00e7') ; $=XML_('ñ','#x00f1'); $=XML_('╫',"boxVh")     ; $=XML_('↑',"uarr")
$=XML_('ê',"ecirc")  ; $=XML_('Ñ',"Ntilde"); $=XML_('╪',"boxvH")     ; $=XML_('↑',"uparrow")
$=XML_('ê','#x00ea') ; $=XML_('Ñ','#x00d1'); $=XML_('┘',"boxul")     ; $=XML_('↑',"ShortUpArrow")
$=XML_('ë',"euml")   ; $=XML_('¿',"iquest"); $=XML_('┌',"boxdr")     ; $=XML_('↓',"darr")
$=XML_('ë','#x00eb') ; $=XML_('⌐',"bnot")  ; $=XML_('█',"block")     ; $=XML_('↓',"downarrow")
$=XML_('è',"egrave") ; $=XML_('¬',"not")   ; $=XML_('▄',"lhblk")     ; $=XML_('↓',"ShortDownArrow")
$=XML_('è','#x00e8') ; $=XML_('½',"frac12"); $=XML_('▀',"uhblk")     ; $=XML_('←',"larr")
$=XML_('ï',"iuml")   ; $=XML_('½',"half")  ; $=XML_('α',"alpha")     ; $=XML_('←',"leftarrow")
$=XML_('ï','#x00ef') ; $=XML_('¼',"frac14"); $=XML_('ß',"beta")      ; $=XML_('←',"ShortLeftArrow")
$=XML_('î',"icirc")  ; $=XML_('¡',"iexcl") ; $=XML_('ß',"szlig")     ; $=XML_('1c'x,"rarr")
$=XML_('î','#x00ee') ; $=XML_('«',"laqru") ; $=XML_('ß','#x00df')    ; $=XML_('1c'x,"rightarrow")
$=XML_('ì',"igrave") ; $=XML_('»',"raqru") ; $=XML_('Γ',"Gamma")     ; $=XML_('1c'x,"ShortRightArrow")
$=XML_('ì','#x00ec') ; $=XML_('░',"blk12") ; $=XML_('π',"pi")        ; $=XML_('!',"excl")
$=XML_('Ä',"Auml")   ; $=XML_('▒',"blk14") ; $=XML_('Σ',"Sigma")     ; $=XML_('"',"apos")
$=XML_('Ä','#x00c4') ; $=XML_('▓',"blk34") ; $=XML_('σ',"sigma")     ; $=XML_('$',"dollar")
$=XML_('Å',"Aring")  ; $=XML_('│',"boxv")  ; $=XML_('µ',"mu")        ; $=XML_("'","quot")
$=XML_('Å','#x00c5') ; $=XML_('┤',"boxvl") ; $=XML_('τ',"tau")       ; $=XML_('*',"ast")
$=XML_('É',"Eacute") ; $=XML_('╡',"boxvL") ; $=XML_('Φ',"phi")       ; $=XML_('/',"sol")
$=XML_('É','#x00c9') ; $=XML_('╢',"boxVl") ; $=XML_('Θ',"Theta")     ; $=XML_(':',"colon")
$=XML_('æ',"aelig")  ; $=XML_('╖',"boxDl") ; $=XML_('δ',"delta")     ; $=XML_('<',"lt")
$=XML_('æ','#x00e6') ; $=XML_('╕',"boxdL") ; $=XML_('∞',"infin")     ; $=XML_('=',"equals")
$=XML_('Æ',"AElig")  ; $=XML_('╣',"boxVL") ; $=XML_('φ',"Phi")       ; $=XML_('>',"gt")
$=XML_('Æ','#x00c6') ; $=XML_('║',"boxV")  ; $=XML_('ε',"epsilon")   ; $=XML_('?',"quest")
$=XML_('ô',"ocirc")  ; $=XML_('╗',"boxDL") ; $=XML_('∩',"cap")       ; $=XML_('_',"commat")
$=XML_('ô','#x00f4') ; $=XML_('╝',"boxUL") ; $=XML_('≡',"equiv")     ; $=XML_('[',"lbrack")
$=XML_('ö',"ouml")   ; $=XML_('╜',"boxUl") ; $=XML_('±',"plusmn")    ; $=XML_('\',"bsol")
$=XML_('ö','#x00f6') ; $=XML_('╛',"boxuL") ; $=XML_('±',"pm")        ; $=XML_(']',"rbrack")
$=XML_('ò',"ograve") ; $=XML_('┐',"boxdl") ; $=XML_('±',"PlusMinus") ; $=XML_('^',"Hat")
$=XML_('ò','#x00f2') ; $=XML_('└',"boxur") ; $=XML_('≥',"ge")        ; $=XML_('`',"grave")
$=XML_('û',"ucirc")  ; $=XML_('┴',"bottom"); $=XML_('≤',"le")        ; $=XML_('{',"lbrace")
$=XML_('û','#x00fb') ; $=XML_('┴',"boxhu") ; $=XML_('÷',"div")       ; $=XML_('{',"lcub")
$=XML_('ù',"ugrave") ; $=XML_('┬',"boxhd") ; $=XML_('÷',"divide")    ; $=XML_('|',"vert")
$=XML_('ù','#x00f9') ; $=XML_('├',"boxvr") ; $=XML_('≈',"approx")    ; $=XML_('|',"verbar")
$=XML_('ÿ',"yuml")   ; $=XML_('─',"boxh")  ; $=XML_('∙',"bull")      ; $=XML_('}',"rbrace")
$=XML_('ÿ','#x00ff') ; $=XML_('┼',"boxvh") ; $=XML_('°',"deg")       ; $=XML_('}',"rcub")
$=XML_('Ö',"Ouml")   ; $=XML_('╞',"boxvR") ; $=XML_('·',"middot")    ; $=XML_('Ç',"Ccedil")
$=XML_('Ö','#x00d6') ; $=XML_('╟',"boxVr") ; $=XML_('·',"middledot") ; $=XML_('Ç','#x00c7')
$=XML_('Ü',"Uuml")   ; $=XML_('╚',"boxUR") ; $=XML_('·',"centerdot") ; $=XML_('ü',"uuml")
$=XML_('Ü','#x00dc') ; $=XML_('╔',"boxDR") ; $=XML_('·',"CenterDot") ; $=XML_('ü','#x00fc')
$=XML_('¢',"cent")   ; $=XML_('╩',"boxHU") ; $=XML_('√',"radic")     ; $=XML_('é',"eacute")
$=XML_('£',"pound")  ; $=XML_('╦',"boxHD") ; $=XML_('²',"sup2")      ; $=XML_('é','#x00e9')
$=XML_('¥',"yen")    ; $=XML_('╠',"boxVR") ; $=XML_('■',"square ")   ; $=XML_('â',"acirc")

          if amper  then $=xml_(?,  "amp")       /*Was there an ampersand?  Translate it*/
          if semi   then $=xml_(??, "semi")      /* "   "     " semicolon?      "      "*/
          return $
/*──────────────────────────────────────────────────────────────────────────────────────*/
create:          items= items + 1                /*bump the count of items in the list. */
          create.items= arg(1)                   /*add item to the  CREATE  list.       */
          create.0    = items                    /*indicate how many items in the list. */
          return
/*──────────────────────────────────────────────────────────────────────────────────────*/
xml_:     parse arg _                            /*make an XML entity    (&xxxx;)       */
          if pos(_, $)\==0  then return changestr(_, $, "&"arg(2)";")
                                 return $
