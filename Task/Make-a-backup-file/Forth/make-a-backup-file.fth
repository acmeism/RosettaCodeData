: backup ( addr u -- )
   2dup pad place s" .bak" pad +place
   2dup pad count rename-file throw
   w/o create-file throw
   s" This is a test string." 2 pick write-file throw
   close-file throw ;

s" testfile" backup
