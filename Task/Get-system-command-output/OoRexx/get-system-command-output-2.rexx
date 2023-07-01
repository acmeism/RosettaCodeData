cmd='dir tu*.rex /od'
cmd '| rxqueue'
Say 'Output of "'cmd'"'
Say
Do While queued()>0
  parse pull text
  Say text
  End
