#lang racket/base
(require racket/match)

;; Returns a tokenising function based on sep and esc
(define ((tokenise-with-escape sep esc) str)
  (define tsil->string (compose list->string reverse))
  (define (inr rem l-acc acc)
    (match rem
      ['() (if (and (null? acc) (null? l-acc)) null (reverse (cons (tsil->string l-acc) acc)))]
      [(list (== sep)   tl ...) (inr tl null (cons (tsil->string l-acc) acc))]
      [(list (== esc) c tl ...) (inr tl (cons c l-acc) acc)]
      [(list c          tl ...) (inr tl (cons c l-acc) acc)]))
  (inr (string->list str) null null))

;; This is the tokeniser that matches the parameters in the task
(define task-tokeniser (tokenise-with-escape #\| #\^))

(define (report-input-output str)
  (printf "Input:  ~s~%Output: ~s~%~%" str (task-tokeniser str)))

(report-input-output "one^|uno||three^^^^|four^^^|^cuatro|")
(report-input-output "")
(report-input-output "|")
(report-input-output "^")
(report-input-output ".")
