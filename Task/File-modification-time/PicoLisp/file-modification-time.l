(let File "test.file"
   (and
      (info File)
      (prinl (stamp (cadr @) (cddr @))) ) # Print date and time in UTC
   (call 'touch File) )                   # Set modification time to "now"
