/* REXX ---------------------------------------------------------------
* 20.07.2014 Walter Pachl translated from Java
* 21.07.2014 WP allow for blanks in the string
*--------------------------------------------------------------------*/
Parse Arg str
default="TOBEORNOTTOBEORTOBEORNOT"
If str='' Then
  str=default
/* str=space(str,0) */
Say 'str='str
compressed = compress(str)
Say compressed
If str=default Then Do
  cx='[84, 79, 66, 69, 79, 82, 78, 79, 84, 256, 258, 260, 265, 259, 261, 263]'
  If cx==compressed Then Say 'compression ok'
  End
decompressed = decompress(compressed)
Say 'dec='decompressed
If decompressed=str Then Say 'decompression ok'
Exit

compress: Procedure
Parse Arg uncompressed
dict.=''
Do i=0 To 255
  z=d2c(i)
  d.i=z
  dict.z=i
  End
dict_size=256
res='['
w=''
Do i=1 To length(uncompressed)
  c=substr(uncompressed,i,1)
  wc=w||c
  If dict.wc<>'' Then
    w=wc
  Else Do
    res=res||dict.w', '
    dict.wc=dict_size
    dict_size=dict_size+1
    w=c
    End
  End
If w<>'' Then
  res=res||dict.w', '
Return left(res,length(res)-2)']'

decompress: Procedure
Parse Arg compressed
compressed=space(translate(compressed,'','[],'))
d.=''
Do i=0 To 255
  z=d2c(i)
  d.i=z
  End
dict_size=256
Parse Var compressed w compressed
res=d.w
w=d.w
Do i=1 To words(compressed)
  k=word(compressed,i)
  Select
    When d.k<>'' | d.k==' ' then /* allow for blank */
      entry=d.k
    When k=dict_size Then
      entry=w||substr(w,1,1)
    Otherwise
      Say "Bad compressed k: "  k
    End
  res=res||entry
  d.dict_size=w||substr(entry,1,1)
  dict_size=dict_size+1
  w=entry
  End
Return res
