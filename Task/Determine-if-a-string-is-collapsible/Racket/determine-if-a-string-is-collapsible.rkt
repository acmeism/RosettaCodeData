#lang racket

(define (collapse text)
  (if (< (string-length text) 2)
      text
      (string-append
       (if (equal? (substring text 0 1) (substring text 1 2))
           "" (substring text 0 1))
       (collapse (substring text 1)))))

; Test cases
(define tcs
  '(""
    "\"If I were two-faced, would I be wearing this one?\" --- Abraham Lincoln "
    "..1111111111111111111111111111111111111111111111111111111111111117777888"
    "I never give 'em hell, I just tell the truth, and they think it's hell. "
    "                                                   ---  Harry S Truman  "
    "The better the 4-wheel drive, the further you'll be from help when ya get stuck!"
    "headmistressship"
    "aardvark"
    "😍😀🙌💃😍😍😍🙌"))

(for ([text tcs])
  (let ([collapsed (collapse text)])
    (display (format "Original  (size ~a): «««~a»»»\nCollapsed (size ~a): «««~a»»»\n\n"
                     (string-length text) text
                     (string-length collapsed) collapsed))))
