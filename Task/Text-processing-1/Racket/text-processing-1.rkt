#lang racket
;; Use SRFI 48 to make %n.nf formats convenient.
(require (prefix-in srfi/48: srfi/48)) ; SRFI 48: Intermediate Format Strings

;; Parameter allows us to used exact decimal strings
(read-decimal-as-inexact #f)

;; files to read is a sequence, so it could be either a list or vector of files
(define (text-processing/1 files-to-read)

  (define (print-line-info d r a t)
    (srfi/48:format #t "Line: ~11F  Reject: ~2F  Accept: ~2F  Line_tot: ~10,3F  Line_avg: ~10,3F~%"
                    d r a t (if (zero? a) +nan.0 (/ t a))))

  ;; returns something that can be used as args to an apply
  (define (handle-and-tag-max consecutive-false tag max-consecutive-false max-false-tags)
   (let ((consecutive-false+1 (add1 consecutive-false)))
     (list consecutive-false+1
           (max max-consecutive-false consecutive-false+1)
           (cond ((= consecutive-false+1 max-consecutive-false) (cons tag max-false-tags))
                 ((= consecutive-false max-consecutive-false) (list tag))
                 (else max-false-tags)))))

  (define (sub-t-p/1 N sum consecutive-false max-consecutive-false max-false-tags)
    (for/fold ((N N) (sum sum) (consecutive-false consecutive-false) (max-consecutive-false max-consecutive-false) (max-false-tags max-false-tags))
      ((l (in-lines)))
      (match l
        [(app string-split `(,tag ,(app string->number vs.ss) ...))
         (let get-line-pairs
           ((vs.ss vs.ss) (line-N 0) (reject 0) (line-sum 0) (consecutive-false consecutive-false)
            (max-consecutive-false max-consecutive-false) (max-false-tags max-false-tags))
           (match vs.ss
             ['()
              (print-line-info tag reject line-N line-sum)
              (values (+ N line-N) (+ sum line-sum) consecutive-false max-consecutive-false max-false-tags)]
             [(list-rest v (? positive?) tl)
              (get-line-pairs tl (add1 line-N) reject (+ line-sum v) 0 max-consecutive-false max-false-tags)]
             [(list-rest _ _ tl)
                (apply get-line-pairs tl line-N (add1 reject) line-sum
                       (handle-and-tag-max consecutive-false tag max-consecutive-false max-false-tags))]))]
        (x (fprintf (current-error-port) "mismatch ~s~%" x)
           (values N sum consecutive-false max-consecutive-false max-false-tags)))))

  (for/fold ((N 0) (sum 0) (consecutive-false 0) (max-consecutive-false 0) (max-false-tags null))
    ((f files-to-read))
    (with-input-from-file f
      (lambda () (sub-t-p/1 N sum consecutive-false max-consecutive-false max-false-tags)))))

(let ((files (vector->list (current-command-line-arguments))))
  (let-values (([N sum consecutive-false max-consecutive-false max-false-tags] (text-processing/1 files)))
    (srfi/48:format #t "~%File(s)  = ~a~%Total    = ~10,3F~%Readings = ~6F~%" (string-join files) sum N)
    (unless (zero? N) (srfi/48:format #t "Average  = ~10,3F~%" (/ sum N)))
    (srfi/48:format #t "~%Maximum run(s) of ~a consecutive false readings ends at line starting with date(s): ~a~%"
                    max-consecutive-false (string-join max-false-tags))))
