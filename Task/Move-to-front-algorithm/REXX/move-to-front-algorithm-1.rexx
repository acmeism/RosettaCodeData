/* REXX ***************************************************************
* 25.05.2014 Walter Pachl
* REXX strings start with position 1
**********************************************************************/
Call enc_dec 'broood'
Call enc_dec 'bananaaa'
Call enc_dec 'hiphophiphop'
Exit
enc_dec: Procedure
Parse Arg in
st='abcdefghijklmnopqrstuvwxyz'
sta=st /* remember this for decoding */
enc=''
Do i=1 To length(in)
  c=substr(in,i,1)
  p=pos(c,st)
  enc=enc (p-1)
  st=c||left(st,p-1)substr(st,p+1)
  End
Say ' in='in
Say 'sta='sta 'original symbol table'
Say 'enc='enc
Say ' st='st  'symbol table after encoding'
out=''
Do i=1 To words(enc)
  k=word(enc,i)+1
  out=out||substr(sta,k,1)
  sta=substr(sta,k,1)left(sta,k-1)substr(sta,k+1)
  End
Say 'out='out
Say ' '
If out==in Then Nop
Else
  Say 'all wrong!!'
Return
