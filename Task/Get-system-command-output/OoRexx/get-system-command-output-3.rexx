dir='dir.dir'
cmd='dir t*.rex /od'
cmd '>'dir
'dir tu*.rex /od >'dir
Say 'Output of "'cmd'"'
Say
Do While lines(dir)>0
  Say linein(dir)
  End
Call lineout oid
