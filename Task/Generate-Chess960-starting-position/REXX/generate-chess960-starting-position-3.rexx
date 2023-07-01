/*---------------------------------------------------------------
* Compute the 960 possible solutions
* There must be at least one field between the rooks
* The king is positioned on any field between the rooks
* The queen is placed on any unoccupied field
* bishops are placed so that they are on different colored fields
* what remains are the kNights...
*--------------------------------------------------------------*/
cnt.=0
Call time 'R'
Do r1=1 To 6
  Do r2=r1+1 To 8
    Do kk=r1+1 To r2-1
      poss=space(translate('12345678',' ',r1||kk||r2),0)
      Call rest
      End

 End
  End
say cnt.1 'solutions'
Say time('E')
Exit

rest:
Do i=1 To 5
  q=substr(poss,i,1)
  br=space(translate(poss,' ',q),0)
  Do b1i=1 To 3
    Do b2i=b1i+1 To 4
      Call finish
      End
    End
  End
Return

finish:
  b1=substr(br,b1i,1)
  b2=substr(br,b2i,1)
  If (b1+b2)//2>0 Then
    Call out
  Return

out:
  pos.='N'
  pos.r1='R'
  pos.r2='R'
  pos.kk='K'
  pos.q='Q'
  pos.b1='B'
  pos.b2='B'
  ol=''
  Do k=1 To 8
    ol=ol||pos.k
    End
  cnt.1=cnt.1+1
  If cnt.1<4 |,
     cnt.1>957 Then
    Say format(cnt.1,3) poss r1 kk r2  ol
  If cnt.1=4 Then
    Say '    ...'
  Return
