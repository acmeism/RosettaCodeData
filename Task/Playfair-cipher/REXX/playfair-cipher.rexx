/*REXX program implements a   PLAYFAIR cipher   (encryption  and  decryption).          */
@abc= 'abcdefghijklmnopqrstuvwxyz';  @abcU= @abc /*literals for  lower and upper  ABC's.*/
parse arg omit key  '('  text                    /*TEXT  is the phrase to be used.      */
oldKey= key                                      /*save the old key.                    */
if key =='' | key ==','    then do;       key= 'Playfair example.'
                                       oldKey= key "   ◄───using the default."
                                end
if omit=='' | omit==','    then omit= 'J'        /*the  "omitted"  character string.    */
if text=''                 then text= 'Hide the gold in the tree stump!!'     /*default.*/
upper omit @abcU                                 /*uppercase OMIT characters & alphabet.*/
@cant= 'can''t contain the "OMIT" character: '  omit       /*literal used in error text.*/
@uchars= 'unique characters.'                    /*a literal used below in an error msg.*/
newKey = scrub(key, 1)                           /*scrub old cipher key  ──►  newKey    */
newText= scrub(text  )                           /*  "    "     text     ──►  newText   */
if newText==''             then call err 'TEXT is empty or has no letters.'
if length(omit)\==1        then call err 'OMIT letter must be only one letter.'
if \datatype(omit, 'M')    then call err 'OMIT letter must be a Latin alphabet letter.'
if pos(omit, newText)\==0  then call err 'TEXT'        @cant
if pos(omit, newKey) \==0  then call err 'cipher key'  @cant
fill= space( translate(@abcU, , omit),  0)       /*elide OMIT characters from alphabet. */
xx= 'X'                                          /*character used for double characters.*/
if omit==xx  then xx= 'Q'                        /*    "       "   "     "       "      */
if length(newKey)<3        then call err 'cipher key is too short, must be ≥ 3' @uchars
fill= space( translate(fill, , newKey), 0)       /*remove any cipher characters.        */
grid= newKey || fill                             /*only first  25  characters are used. */
say 'old cipher key: '  strip(oldKey)
say 'new cipher key: '  newKey
say '     omit char: '  omit
say '   double char: '  xx
say ' original text: '  strip(text)
padL= 14 + 2
call show 'cleansed', newText
#= 0                                             /*number of grid characters used.      */
         do row   =1  for 5                      /*build array of individual cells.     */
            do col=1  for 5;                 #= # + 1;       @.row.col= substr(grid, #, 1)
            if row==1  then            @.0.col= @.1.col
            if col==5  then do;        @.row.6= @.row.1;     @.row.0= @.row.5;    end
            if row==5  then do;        @.6.col= @.1.col;     @.0.col= @.5.col;    end
            end   /*col*/
         end      /*row*/
pad = left('', padL)
padX= left('', padL, "═")'Playfair'
Lxx = translate(xx, @abc, @abcU)                 /* [↓]  lowercase of double character. */
LxxLxx= Lxx || Lxx                               /* [↓]  doubled version of  Lxx.       */
eText= .Playfair(newText, 1);          call show 'encrypted' , eText
pText= .Playfair(eText     );          call show 'plain'     , pText
qText= changestr(xx  || xx, pText, Lxx)          /*change doubled doublechar ──► single.*/
qText= changestr(Lxx || xx, qText, LxxLxx)       /*change  xx ──► lowercase dblCharacter*/
qText= space( translate( qText, , xx), 0)        /*remove character used for "doubles". */
upper qText                                      /*reinstate the use of upper characters*/
if length(qText)\==length(pText)  then call show 'possible',  qText
say ' original text: '  newText;       say       /*··· and also show the original text. */
if qtext==newText  then say padx 'encryption──► decryption──► encryption worked.'
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
@@:    parse arg Xrow,Xcol;                         return  @.Xrow.Xcol
err:   say;   say '***error!***'  arg(1);           say;    exit 13
LR:    rowL= row(left(__, 1)); colL= _; rowR= row(right(__,1)); colR= _; return length(__)
row:   ?= pos(arg(1), grid);      _= (?-1) // 5  +  1;      return  (4+?) % 5
show:  arg ,y; say; say right(arg(1) 'text: ',padL) digram(y); say pad space(y, 0); return
/*──────────────────────────────────────────────────────────────────────────────────────*/
.Playfair: arg T,encrypt;         i= -1;     if encrypt==1  then i= 1;          $=
                    do k=1  while  i==1;     _= substr(T, k, 1);     if _==' '  then leave
                    if _==substr(T, k+1, 1)  then T= left(T, k) || Lxx || substr(T, k + 1)
                    end     /*k*/
           upper T
                    do j=1  by 2  to length(T);     __= strip( substr(T, j, 2) )
                    if LR()==1  then __= __ || xx;  call LR /*append X or Q char, rule 1*/
                      select                                                      /*rule*/
                      when rowL==rowR  then __= @@(rowL,   colL+i)@@(rowR,   colR+i) /*2*/
                      when colL==colR  then __= @@(rowL+i, colL  )@@(rowR+i, colR)   /*3*/
                      otherwise             __= @@(rowL,   colR  )@@(rowR,   colL)   /*4*/
                      end   /*select*/
                    $= $ || __
                    end     /*j*/
           return $
/*──────────────────────────────────────────────────────────────────────────────────────*/
digram: procedure; parse arg x,,$;          do j=1  by 2  to length(x)
                                            $= $  ||  substr(x, j, 2)' '
                                            end   /*j*/
        return strip($)
/*──────────────────────────────────────────────────────────────────────────────────────*/
scrub:  procedure; arg xxx,unique;    xxx= space(xxx, 0)      /*ARG capitalizes all args*/
        $=;            do j=1  for length(xxx);    _= substr(xxx, j, 1)
                       if unique==1  then  if  pos(_, $)\==0  then iterate  /*is unique?*/
                       if datatype(_, 'M')  then $= $  ||  _  /*only use Latin letters. */
                       end   /*j*/
        return $
