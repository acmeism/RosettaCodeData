/*REXX program  displays the lyrics of the song "The Name Game" by Shirley Ellis.  */
/* 20230526 Walter Pachl refurbished Gerald Schildberger's original program        */
Parse Arg namelist                          /*obtain optional argument(s) from C.L.*/
If namelist='' Then                         /*Not specified?                       */
  namelist="gAry, eARL, billy, FeLix, MarY" /*  Then use the default.              */
                                            /* [?]  names separated by commas.     */
Do While namelist>''
  namelist=space(namelist)                  /*elide superfluous blanks from list.  */
  Parse Var namelist name',' namelist       /*get name (could be 2 words) from list*/
  call song name                            /*invoke subroutine to display lyrics. */
  End
Exit                                        /*stick a fork in it,  we're all Done. */
/*---------------------------------------------------------------------------------*/
song:
  Parse Arg name
  Parse Value 'b f m' With bb ff mm
  lowercase='abcdefghijklmnopqrstuvwxyz'     /*build 2 alphabets*/
  uppercase=translate(lowercase)
  name =translate(left(name,1),uppercase,lowercase)||,
        translate(substr(name,2),lowercase,uppercase)
  namel=translate(name,lowercase,uppercase)
  Parse Var name first +1 rest
  Select
    When pos(first,'AEIOU')>0 Then Do
      Say name','  name", bo-b"namel
      Say 'Banana-fana fo-f'namel
      Say 'Fee-fi-mo-m'namel
      End
    When pos(first,'BFM')>0 Then Do
      Select
        When first=='B' Then bb=''
        When first=='F' Then ff=''
        When first=='M' Then mm=''
        End
      Say name',' name', bo-'bb||rest
      Say 'Banana-fana fo-'ff||rest
      Say 'Fee-fi-mo-'mm||rest
      End
    Otherwise Do
      Say name','  name', bo-b'rest
      Say 'Banana-fana fo-f'rest
      Say 'Fee-fi-mo-m'rest
      End
    End /*select*/
    Say name'!'
    Say ''
    Return
