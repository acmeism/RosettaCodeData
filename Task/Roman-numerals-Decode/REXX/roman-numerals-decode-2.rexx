/*REXX program to convert Roman numeral number(s) to Arabic number(s).  */
rYear = 'MCMXC'    ;      say right(rYear,9)':'   rom2dec(rYear)
rYear = 'mmviii'   ;      say right(rYear,9)':'   rom2dec(rYear)
rYear = 'MDCLXVI'  ;      say right(rYear,9)':'   rom2dec(rYear)
exit

rom2dec: procedure;  arg roman .
if verify(roman,'MDCLXVI')\==0  then do
                                     say  'invalid Roman number:'  roman
                                     return '***error!***'
                                     end
#=rChar(right(roman,1))                    /*start with the last numeral*/
            do j=1  for length(roman) - 1
            x=rChar(substr(roman,j  ,1))   /*the current Roman numeral. */
            y=rChar(substr(roman,j+1,1))   /*the    next Roman numeral. */
            if x<y  then # = #-x           /* x<y ?    Then subtract it.*/
                    else # = #+x           /* x≥y ?    Then add it.     */
            end   /*j*/
return #

rChar: procedure;  arg _       /*convert a Roman number to an Arabic dig*/
if _=='I'  then return    1
if _=='V'  then return    5
if _=='X'  then return   10
if _=='L'  then return   50
if _=='C'  then return  100
if _=='D'  then return  500
if _=='M'  then return 1000
                return    0    /*_ is an invalid Roman numeral (char).  */
