Parse Version v
Say v
l.=0
Call mk_array 1,3,4,34,25,9,12,36,56,36
Call mk_array 2,2,8,81,169,34,55,76,49,7
Call mk_array 3,75,121,75,144,3,5,16,46,35
st.0=0
Do li=1 To 3
  Do ii=1 To l.li.0
    If is_square(l.li.ii) Then
      Call store l.li.ii
    End
  End
Call Show
Exit

mk_array:
an=arg(1)
Do i=1 To arg()-1
  l.an.i=arg(i+1)
  End
l.an.0=arg()-1
Return

is_square:
Parse Arg x
Do i=1 By 1 Until i**2>x
  if i**2=x Then Return 1
  End
Return 0

store:
Parse Arg e
do i=1 To st.0
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
