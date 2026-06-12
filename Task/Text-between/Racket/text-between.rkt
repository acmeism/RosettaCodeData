#lang racket
(require (prefix-in 13: srfi/13))

(define (text-to-end text end)
  (cond [(13:string-contains text end) => (λ (i) (substring text 0 i))]
        [else text]))

(define (text-from-start text start)
  (cond [(13:string-contains text start) => (λ (i) (substring text (+ i (string-length start))))]
        [else ""]))

(define text-between
  (match-lambda**
   [("start" "end" text) text]
   [("start" end text) (text-to-end text end)]
   [(start "end" text) (text-from-start text start)]
   [(start end text) (text-to-end (text-from-start text start) end)]))

(module+ test
  (require rackunit)

  (define (test-case text start end output)
    (check-equal? (text-between start end text) output))

  (test-case "Hello Rosetta Code world" "Hello " " world" "Rosetta Code")
  (test-case "Hello Rosetta Code world" "start" " world" "Hello Rosetta Code")
  (test-case "Hello Rosetta Code world" "Hello" "end" " Rosetta Code world")
  (test-case "</div><div style=\"chinese\">你好嗎</div>" "<div style=\"chinese\">" "</div>" "你好嗎")
  (test-case "<text>Hello <span>Rosetta Code</span> world</text><table style=\"myTable\">" "<text>" "<table>" "Hello <span>Rosetta Code</span> world</text><table style=\"myTable\">")
  (test-case "<table style=\"myTable\"><tr><td>hello world</td></tr></table>" "<table>" "</table>" "")
  (test-case "The quick brown fox jumps over the lazy other fox" "quick " " fox" "brown")
  (test-case "One fish two fish red fish blue fish" "fish " " red" "two fish")
  (test-case "FooBarBazFooBuxQuux" "Foo" "Foo" "BarBaz"))
