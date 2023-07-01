address hostemu 'execio * diskr "./st.in" (finis stem in.'
Say in.0 'lines in file st.in'
v=''
Do i=1 To in.0
  Say i '>'in.i'<'
  v=v||in.i
  End
say 'v='v
::requires "hostemu" LIBRARY
