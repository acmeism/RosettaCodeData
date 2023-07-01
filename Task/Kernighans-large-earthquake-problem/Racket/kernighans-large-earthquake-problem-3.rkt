#lang racket

(require gregor) ; Date parsing

; test :: IO ()
(module* main #f
  (for
      ([q ((quakesAbove 6)
           (lines (readFile "~/quakes.txt")))])
    (writeln q)))


; quakesAbove :: Int -> [String] -> [(Date, String, Float)]
(define (quakesAbove n)
  (λ (xs)
    ((concatMap
      (λ (x)
        (local [(define-values (dte k mgn)
                  (apply values (string-split x)))
                (define m (string->number mgn))]
          (if (< n m)
              (list (list (parse-date dte "M/d/y") k m))
              '()))))
     xs)))

; GENERIC ---------------------------------------------

; concatMap :: (a -> [b]) -> [a] -> [b]
(define (concatMap f)
  (λ (xs)
    (foldr (λ (x a) (append (f x) a)) '() xs)))

; lines :: String -> [String]
(define (lines s)
  (string-split s "\n"))

; readFile :: FilePath -> IO String
(define (readFile fp)
  (file->string
   (expand-user-path fp)))
