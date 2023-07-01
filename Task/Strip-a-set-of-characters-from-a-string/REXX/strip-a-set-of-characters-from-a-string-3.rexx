/* REXX ***************************************************************
* If source and stripchars don't contain a hex 00 character, this works
* 06.07.2012 Walter Pachl
* 19.06.2013 -"- space(result,0) -> space(result,0,' ')
*                space(result,0) removes WHITESPACE not only blanks
**********************************************************************/
Say 'Sh ws  soul strppr. Sh took my hrt! -- expected'
Say stripchars("She was a soul stripper. She took my heart!","aei")
Exit
stripchars: Parse Arg string,stripchars
result=translate(string,'00'x,' ')      /* turn blanks into '00'x   */
result=translate(result,' ',stripchars) /* turn stripchars into ' ' */
result=space(result,0,' ')              /* remove all blanks        */
Return translate(result,' ','00'x)      /* '00'x back to blanks     */
