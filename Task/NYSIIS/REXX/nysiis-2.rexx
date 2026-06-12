/*REXX program implements the  NYSIIS  phonetic algorithm  (for various test names).    */
@@= "Bishop brown_sr browne_III browne_IV Carlson Carr Chapman D'Souza de_Sousa Franklin",
    "Greene Harper Hoyle-Johnson Jacobs knight Larson Lawrence Lawson Louis_XVI Lynch",
    "Mackenzie Marshall,ESQ Matthews McCormack McDaniel McDonald Mclaughlin mitchell Morrison",
    "O'Banion O'Brien o'daniel Richards Silva Vaughan_Williams Watkins Wheeler Willis Xavier,MD."
parse upper arg z;     if z=''  then z= @@       /*obtain optional name list from the CL*/

        do i=1  for words(z)                     /*process each name (word) in the list.*/
        xx= translate( word(z, i), , '_')        /*reconstitute any blanks using TRANS. */
        say right(xx, 35)   ' ──► '   nysiis(xx) /*display some stuff to the terminal.  */
        end   /*i*/
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
$:     p= substr(x,j-1,1) /*prev*/; n= substr(x,j+1,1) /*next*/; return substr(x,j,arg(1))
vowel: return  pos(arg(1), 'AEIOUaeiou') \== 0   /*returns 1 if the argument has a vowel*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
nysiis:  procedure; arg x;  x= space( translate(x, , ',')) /*elide commas, excess blanks*/
w= words(x);        Lw= word(x, w)               /*pick off the last word in name list. */
@titles= 'ESQ JNR JR SNR SR'                     /* [↓]  last word post─nominal letters?*/
if w\==1  then if pos('IL', lw)==0  then                       /*disallow IL as Roman #.*/
                          if pos(., x)\==0                |,   /*Sr.  Jr.  Esq.  ··· ?  */
                             datatype( left(Lw, 1), 'W')  |,   /*2nd  3rd  4th   ··· ?  */
                             verify(Lw, 'IVXL') ==0       |,   /*Roman numeral suffix?  */
                             wordpos(x, @titles)\==0  then x= subword(x, 1, w-1)
x= space(x, 0)                                   /*remove all whitespace from the name. */
if left(x, 3)=='MAC'                   then x= "MCC"substr(x, 4)     /*start with MAC ? */
if left(x, 2)=='KN'                    then x=   "N"substr(x, 3)     /*  "     "  KN  ? */
if left(x, 1)=='K'                     then x=   "C"substr(x, 2)     /*  "     "  K   ? */
if left(x, 2)=='PH' | left(x,2)=="PF"  then x=  'FF'substr(x, 3)     /*  "     "  PH,PF?*/
if left(x, 3)=='SCH'                   then x= "SSS"substr(x, 4)     /*  "     "  SCH ? */
r2= right(x, 2)
if wordpos(r2, 'EE IE')         \==0   then x= left(x, length(x)-2)"Y" /*ends with ··· ?*/
if wordpos(r2, 'DT RT RD NT ND')\==0   then x= left(x, length(x)-2)"D" /*  "    "   "  "*/
key= left(x, 1)                                                        /*use first char.*/

   do j=2  to length(x); if \datatype($(1), 'U')  then iterate /*¬ Latin letter? Skip it*/
   if $(2)=='EV'   then x= overlay("F", x, j+1)                /*have an  EV ?   Use F  */
                   else x= overlay( translate( $(1), 'AAAAGSN', "EIOUQZM"),  x, j)
   if $(2)=='KN'   then x= left(x, j-1)"N"substr(x, j+1)       /*have a   KN ?   Use N  */
                   else if $(1)=="K"  then x= overlay('C',x,j) /*  "  "   K  ?   Use C  */
   if $(3)=='SCH'  then x= overlay("SSS", x, j)                /*  "  "   SCH?   Use SSS*/
   if $(2)=='PH'   then x= overlay("FF",  x, j)                /*  "  "   PH ?   Use FF */
   if $(1)=='H'    then if \vowel(p) | \vowel(n)  then x= overlay( p , x, j)
   if $(1)=='W'    then if  vowel(p)              then x= overlay("A", x, j)
   if $(1)\== right(key, 1)                       then key= key || $(1) /*append to KEY.*/
   end   /*j*/
                                                                        /* [↓]  elide:  */
if right(key, 1)=='S'   then key= left(key, max(1, length(key) -1))     /*ending S      */
if right(key, 2)=='AY'  then key= left(key,        length(key) -2)"Y"   /*  "    A in AY*/
if right(key, 1)=='A'   then key= left(key, max(1, length(key) -1))     /*  "    A      */
return strip(key)                                /*return the whole key  (all of it).   */
