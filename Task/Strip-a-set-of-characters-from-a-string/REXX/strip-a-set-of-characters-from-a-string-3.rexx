/*╔══════════════════════════════╗ CHANGESTR ╔═════════════════════════╗
╔═╩══════════════════════════════╝ function  ╚═════════════════════════╩═╗
║       new string to be used──────────┐ ┌─────limit of # changes (times)║
║  original string (haystack)────────┐ │ │      [default:  ≈ one billian]║
║       old string to be changed───┐ │ │ │ ┌───begin at this occurance #.║
║ {O, H, and  N  can be null.}     │ │ │ │ │    [default: 1st occurrance]║
╚═╦════════════════════════════╗   │ │ │ │ │   ╔═══════════════════════╦═╝
  ╚════════════════════════════╝   ↓ ↓ ↓ ↓ ↓   ╚═══════════════════════╝*/
changestr: procedure;  parse arg   o,h,n,t,b   /* T and B  are optional.*/
$=''                                           /*$: the returned string.*/
t=word(t  999999999  , 1)                      /*maybe use the default? */
b=word(b  1          , 1)                      /*  "    "   "     "     */
w=length(o)                                    /*length of  OLD  string.*/
if w==0  &  t\=0        then return n || h     /*changing a null char ? */
#=0                                            /*# of changed occurances*/
                do j=1  until # >= t           /*keep changing, T times.*/
                parse var  h y  (o)  _  +(w) h /*parse the string ...   */
                if _=='' then return $ || y    /*no more left, return.  */
                if j<b   then $=$ || y || o    /*didn't meet begin at ? */
                         else do
                              $=$ || y || n    /*build new STR from S.  */
                              #=#+1            /*bump occurance number. */
                              end
                end   /*j*/
                                               /*Most REXX BIFs only ···*/
return $ || h                                  /* support three options.*/
