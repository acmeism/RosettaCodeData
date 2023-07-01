/*REXX program determines what characters are valid for REXX symbols.*/
/* copied from REXX version 2                                        */
Parse Version v
Say v
symbol_characters=''                   /* start with no chars        */
do j=0 To 255                          /* loop through all the chars.*/
  c=d2c(j)                             /* convert number to character*/
  if datatype(c,'S') then              /* Symbol char                */
    symbol_characters=symbol_characters || c  /* add to list.        */
  end
say 'symbol characters:' symbol_characters /*display all             */
