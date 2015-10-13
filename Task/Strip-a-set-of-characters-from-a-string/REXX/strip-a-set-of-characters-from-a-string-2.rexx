/* REXX */
say StripChars('She was a soul stripper. She took my heart!','iea')
exit 0

StripChars: procedure
parse arg strng,remove
removepos=Verify(strng,remove,'MATCH')
if removepos=0 then return strng
parse value strng with strng =(removepos) +1 rest
return strng || StripChars(rest,remove)
