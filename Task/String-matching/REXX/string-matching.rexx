/*REXX program  demonstrates  some  basic   character string   testing  (for matching). */
parse arg A B;                    LB=length(B)   /*obtain A and B from the command line.*/
say 'string  A  = '   A                          /*display string   A   to the terminal.*/
say 'string  B  = '   B                          /*   "       "     B    "  "      "    */
say copies('░', 70)
if left(A, LB)==B  then say  'string  A  starts with string  B'
                   else say  "string  A  doesn't start with string  B"
say                                              /* [↓] another method using COMPARE BIF*/
          /*╔══════════════════════════════════════════════════════════════════════════╗
            ║ if compare(A,B)==LB  then say  'string  A  starts with string  B'        ║
            ║                      else say  "string  A  doesn't start with string  B" ║
            ╚══════════════════════════════════════════════════════════════════════════╝*/
p=pos(B, A)
if p==0  then say  "string  A  doesn't contain string  B"
         else say  'string  A  contains string  B  (starting in position'   p")"
say
if right(A, LB)==b  then say 'string  A  ends with string  B'
                    else say "string  A  doesn't end with string  B"
say
$=;   p=0;                    do  until  p==0;        p=pos(B, A, p+1)
                              if p\==0  then $=$','   p
                              end   /*until*/
$=space(strip($, 'L', ","))                      /*elide extra blanks and leading comma.*/
#=words($)                                       /*obtain number of words in  $  string.*/
if #==0  then say "string  A  doesn't contain string  B"
         else say 'string  A  contains string  B '    #    " time"left('s', #>1),
                  "(at position"left('s',  #>1)   $")"  /*stick a fork in it, we're done*/
