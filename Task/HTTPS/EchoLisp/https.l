;; asynchronous call back definition
(define (success name text) (writeln 'Loaded name) (writeln text))
;;
(file->string success "https:/sourceforge.net")
