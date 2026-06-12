#lang racket

(define (move-to-backup file)
  (define backup
    (regexp-replace #rx"^(.*?)(?:\\.bak([0-9]*))?$" file
      (λ (_ base num) (~a base ".bak" (add1 (if num (string->number num) 0))))))
  (eprintf "~s -> ~s\n" file backup)
  (when (file-exists? backup) (move-to-backup backup))
  (rename-file-or-directory file backup)
  backup)

(define (revise path0)
  (define path (path->string (normalize-path path0))) ; chase symlinks
  (when (file-exists? path) (copy-file (move-to-backup path) path))
  (display-to-file "Another line\n" path #:exists 'append))

(revise "fff")
