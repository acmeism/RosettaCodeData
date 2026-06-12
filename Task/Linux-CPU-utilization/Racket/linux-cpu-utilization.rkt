#lang racket/base

(require racket/string)

(define (get-stats) ; returns total and idle times as two values
  (define line (call-with-input-file* "/proc/stat" read-line))
  (define numbers (map string->number (cdr (string-split line))))
  (values (apply + numbers) (list-ref numbers 3)))

(define prev-stats #f)

(define (report-cpu-utilization)
  ;; lazy: fixed string instead of keeping the last time
  (define prompt (if prev-stats "last second" "since boot"))
  (define-values [cur-total cur-idle] (get-stats))
  (define prev (or prev-stats '(0 0)))
  (set! prev-stats (list cur-total cur-idle))
  (define total (- cur-total (car prev)))
  (define idle (- cur-idle (cadr prev)))
  (printf "Utilization (~a): ~a%\n" prompt
          (/ (round (* 10000 (- 1 (/ idle total)))) 100.0)))

(let loop ()
  (report-cpu-utilization)
  (sleep 1)
  (loop))
