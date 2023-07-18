/*REXX program supports the Caesar cipher for most keyboard characters  */
/*                                                     including blanks.*/
  Parse Arg key text                /* get key and the text to be ciph  */
  Say 'Caesar cipher key:' key      /* echo the Caesar cipher key       */
  Say '       plain text:' text     /* "   "       plain text           */
  code=caesar(text,key)
  Say '         ciphered:' code     /* "   "    ciphered text           */
  back=caesar(code,-key)
  Say '       unciphered:' back     /* "   "  unciphered text           */
  If back\==text Then
    Say "plain text doesn't match unciphered ciphered text."
  Exit                           /* stick a fork in it,  we're all done */
/*----------------------------------------------------------------------*/
caesar: Procedure
  Parse Arg txt,ky
  abcx='abcdefghijklmnopqrstuvwxyz'
  abcx=translate(abcx)abcx"0123456789(){}[]<>'" /*add uppercase, digits */
  abcx=abcx'~!@#$%^&*_+:";?,./`-= ' /* also add other characters     */
  l=length(abcx)                       /* obtain the length of abcx     */
  aky=abs(ky)                          /* absolute value of the key     */
  If aky>length(abcx)-1|ky==0 Then
    Call err ky 'key is invalid.'
  badpos=verify(txt,abcx)              /* any illegal character in txt  */
  If badpos\==0 Then
    Call err 'unsupported character:' substr(txt,badpos,1)
  If ky>0 Then                          /* cipher                        */
    ky=ky+1
  Else                                 /* decipher                      */
    ky=l+1-aky
                                       /* return translated input       */
  Return translate(txt,substr(abcx||abcx,ky,l),abcx)
/*----------------------------------------------------------------------*/
err:
  Say
  Say '***error***'
  Say
  Say arg(1)
  Say
  Exit 13
