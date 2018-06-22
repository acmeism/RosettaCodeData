(if (info "file.txt")
   (prinl "Size: " (car @) " bytes, last modified " (stamp (cadr @) (cddr @)))
   (prinl "File doesn't exist") )

# for directory existing
# Nehal-Singhal 2018-05-25

(if (info "./docs")
  (print 'exists)
  (print 'doesNotExist)))

# To verify if it's really a directory, (CAR of return value will be 'T').
# abu 2018-05-25

  (let I (info "./docs")
      (prinl
         (nond
            (I "Does not exist")
            ((=T (car I)) "Is not a directory")
            (NIL "Directory exists") ) ) )
