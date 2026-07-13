/*REXX program reads a file and stores it as a continuous character str.*/
Parse Version v
iFID = 'st.in'                         /*name of the input file.        */
If left(v,11)='REXX-Regina' |,
   left(v,11)='REXX-ooRexx' Then Do
  len=chars(iFid)                      /*size of the file               */
  v = charin(iFid,,len)                /*read entire file               */
  End
Else Do                                /* for other Rexx Interpreters   */
  v=''
  Do while chars(iFid)>0               /* read the file chunk by chunk  */
    v=v||charin(iFid,,500)
    End
  End
say 'v='v
say 'length(v)='length(v)
