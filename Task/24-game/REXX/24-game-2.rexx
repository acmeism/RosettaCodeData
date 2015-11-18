changestr: Procedure
/* change needle to newneedle in haystack (as often as specified      */
/* or all of them if count is omitted                                 */
  Parse Arg needle,haystack,newneedle,count
  If count>'' Then Do
    If count=0 Then Do
      Say 'chstr count must be > 0'
      Signal Syntax
      End
    End
  res=""
  changes=0
  px=1
  do Until py=0
    py=pos(needle,haystack,px)
    if py>0 then Do
      res=res||substr(haystack,px,py-px)||newneedle
      px=py+length(needle)
      changes=changes+1
      If count>'' Then
        If changes=count Then Leave
      End
    end
  res=res||substr(haystack,px)
  Return res
