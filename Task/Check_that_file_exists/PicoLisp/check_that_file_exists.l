(if (info "file.txt")
   (prinl "Size: " (car @) " bytes, last modified " (stamp (cadr @) (cddr @)))
   (prinl "File doesn't exist") )
