/*REXX program supports the Caesar cipher for the Latin alphabet only,  */
/* no punctuation or blanks allowed, lowercase is treated as uppercase. */
Parse Upper Arg key text     /* get key & uppercased text to be ciphered*/
text=space(text,0)           /* elide any and blanks                    */
Say 'Caesar cipher key:' key      /* echo the Caesar cipher key         */
Say '       plain text:' text     /*   "   "       plain text           */
code=caesar(text,key)
Say '         ciphered:' code     /*   "   "    ciphered text           */
back=caesar(code,-key)
Say '       unciphered:' back     /*   "   "  unciphered text           */
If back\==text Then
  Say "unciphered text doesn't match plain text."
Exit                              /* stick a fork in it,  we're all done*/
/*----------------------------------------------------------------------*/
caesar: Procedure
  Parse Arg text,key
  abc='ABCDEFGHIJKLMNOPQRSTUVWXYZ'
  If abs(key)>length(abc)-1|key==0 Then
    Call err 'key ('key') is invalid.'
  badpos=verify(text,abc)          /* any illegal character in the text */
  If badpos\==0 Then
    Call err 'unsupported character:' substr(text,badpos,1)
  If key>0 Then                        /* cipher                        */
    key2=key+1
  Else                                 /* decipher                      */
    key2=length(abc)+key+1
  Return translate(text,substr(abc||abc,key2,length(abc)),abc)
/*----------------------------------------------------------------------*/
err:
  Say
  Say '***error***'
  Say
  Say arg(1)
  Say
  Exit 13
