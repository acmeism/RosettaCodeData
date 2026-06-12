Parse Version v
Say v
l.1=.array~of(3,4,34,25,9,12,36,56,36)
l.2=.array~of(2,8,81,169,34,55,76,49,7)
l.3=.array~of(75,121,75,144,35,16,46,35)
st.0=0
Do li=1 To 3
  Do e over l.li
    If is_square(e) Then
      Call store s
    End
  End
Call Show
Exit

is_square:
Parse Arg x
Do i=1 By 1 UNtil i**2>x
  if i**2=x Then Return 1
  End
Return 0

store:
do i=1 To st.0
  /*
  If st.i=e Then
    Return
  */
  If st.i>e Then Do
    Do j=st.0 To i By -1
      ja=j+1
      st.ja=st.j
      End
    st.0=st.0+1
    Leave i
    End
  End
st.i=e
If i>st.0 Then
  st.0=i
Return

show:
ol='Ordered squares:'
Do i=1 To st.0
  ol=ol st.i
  End
Say ol
Exit
