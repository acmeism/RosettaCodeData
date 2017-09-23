/* Also works with Regina if you state OPTIONS AREXX_BIFS ; OPTIONS AREXX_SEMANTICS */
filename='file.txt'
contents=''
IF Open(filehandle,filename,'READ')
THEN DO UNTIL EOF(filehandle)
   line=ReadLn(filehandle)
   SAY line
   contents=contents || line || '0a'x
   END
ELSE EXIT 20
CALL Close filehandle
EXIT 0
