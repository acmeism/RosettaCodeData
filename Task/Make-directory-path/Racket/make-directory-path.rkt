#lang racket
(define path-str "/tmp/woo/yay")
(define path/..-str "/tmp/woo")

;; clean up from a previous run
(when (directory-exists? path-str)
  (delete-directory path-str)
  (delete-directory path/..-str))
;; delete-directory/files could also be used -- but that requires goggles and rubber
;; gloves to handle safely!

(define (report-path-exists)
  (printf "~s exists (as a directory?):~a~%~s exists (as a directory?):~a~%~%"
          path/..-str (directory-exists? path/..-str)
          path-str (directory-exists? path-str)))

(report-path-exists)

;; Really ... this is the only bit that matters!
(make-directory* path-str)

(report-path-exists)
