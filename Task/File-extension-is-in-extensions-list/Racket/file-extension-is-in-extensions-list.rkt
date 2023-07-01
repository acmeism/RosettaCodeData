#lang racket

(define extensions '(".zip"
                     ".rar"
                     ".7z"
                     ".gz"
                     ".archive"
                     ".a##"
                     ".tar.bz2"))

(define filenames '("MyData.a##"
                    "MyData.tar.Gz"
                    "MyData.gzip"
                    "MyData.7z.backup"
                    "MyData..."
                    "MyData"
                    "MyData_v1.0.tar.bz2"
                    "MyData_v1.0.bz2"))

(define (string-right s n)
    (if (< (string-length s) n)
        s
        (substring s (- (string-length s) n))))

(define (file-extension-in-list? f lst)
  (let ([lcase (string-downcase f)])
    (ormap (lambda (x) (equal? (string-right lcase (string-length x)) x)) extensions)))

(for ((f (in-list filenames)))
  (printf "~a ~a~%" (~a #:width 20 f) (file-extension-in-list? f extensions)))
