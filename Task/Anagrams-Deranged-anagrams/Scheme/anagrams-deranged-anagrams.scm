(import (scheme base)
        (scheme char)
        (scheme cxr)
        (scheme file)
        (scheme write)
        (srfi 1)    ; lists
        (srfi 132)) ; sorting library

;; read in word list, and sort into decreasing length
(define (read-ordered-words)
  (with-input-from-file
    "unixdict.txt"
    (lambda ()
      (do ((line (read-line) (read-line))
           (words '() (cons line words)))
        ((eof-object? line)
         (list-sort (lambda (a b) (> (string-length a) (string-length b)))
                    words))))))

(define (find-deranged-words word-list)
  (define (search words)
    (let loop ((word-chars (let ((chars (map string->list words)))
                             (zip chars
                                  (map (lambda (word) (list-sort char<? word))
                                       chars)))))
      (if (< (length word-chars) 2)
        #f ; failed to find any
        (let ((deranged-word ; seek a deranged version of the first word in word-chars
                (find (lambda (chars)
                        (and (equal? (cadar word-chars) (cadr chars)) ; check it's an anagram?
                             (not (any char=? (caar word-chars) (car chars))))) ; and deranged?
                      word-chars)))
          (if deranged-word ; if we got one, return it with the first word
            (map list->string (list (caar word-chars) (car deranged-word)))
            (loop (cdr word-chars)))))))
  ;
  (let loop ((rem word-list))
    (if (null? rem)
      '()
      (let* ((len (string-length (car rem)))
             (deranged-words (search ; look through group of equal sized words
                               (take-while (lambda (word) (= len (string-length word)))
                                           (cdr rem)))))
        (if deranged-words
          deranged-words
          (loop (drop-while (lambda (word) (= len (string-length word)))
                            (cdr rem))))))))

(display (find-deranged-words (read-ordered-words))) (newline)
