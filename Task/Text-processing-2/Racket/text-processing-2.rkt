#lang racket
(read-decimal-as-inexact #f)
;; files to read is a sequence, so it could be either a list or vector of files
(define (text-processing/2 files-to-read)
  (define seen-datestamps (make-hash))
  (define (datestamp-seen? ds) (hash-ref seen-datestamps ds #f))
  (define (datestamp-seen! ds pos) (hash-set! seen-datestamps ds pos))

  (define (fold-into-pairs l (acc null))
    (match l ['() (reverse acc)]
      [(list _) (reverse (cons l acc))]
      [(list-rest a b tl) (fold-into-pairs tl (cons (list a b) acc))]))

  (define (match-valid-field line pos)
    (match (string-split line)
      ;; if we don't hit an error, then the file is valid
      ((list-rest (not (pregexp #px"[[:digit:]]{4}-[[:digit:]]{2}-[[:digit:]]{2}")) _)
       (error 'match-valid-field "invalid format non-datestamp at head: ~a~%" line))

      ;; check for duplicates
      ((list-rest (? datestamp-seen? ds) _)
       (printf "duplicate datestamp: ~a at line: ~a (first seen at: ~a)~%"
               ds pos (datestamp-seen? ds))
       #f)

      ;; register the datestamp as seen, then move on to rest of match
      ((list-rest ds _) (=> next-match-rule) (datestamp-seen! ds pos) (next-match-rule))

      ((list-rest
        _
        (app fold-into-pairs
             (list (list (app string->number (and (? number?) vs))
                         (app string->number (and (? integer?) statuss)))
                   ...)))
       (=> next-match-rule)
       (unless (= (length vs) 24) (next-match-rule))
       (not (for/first ((s statuss) #:unless (positive? s)) #t)))

      ;; if we don't hit an error, then the file is valid
      (else (error 'match-valid-field "bad field format: ~a~%" line))))

  (define (sub-t-p/1)
    (for/sum ((line (in-lines))
              (line-number (in-naturals 1)))
      (if (match-valid-field line line-number) 1 0)))
  (for/sum ((file-name files-to-read))
    (with-input-from-file file-name sub-t-p/1)))

(printf "~a records have good readings for all instruments~%"
        (text-processing/2 (current-command-line-arguments)))
