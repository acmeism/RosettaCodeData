#lang racket

; largeQuakes :: Int -> [String] -> [String]
(define (largeQuakes n xs)
  (filter
   (λ (x)
     (< n (string->number (last (string-split x)))))
   xs))

; main :: IO ()
(module* main #f
  (display
   (unlines
    (largeQuakes
     6
     (lines (readFile "~/quakes.txt"))))))


; GENERIC ---------------------------------------------

; lines :: String -> [String]
(define (lines s)
  (string-split s "\n"))

; readFile :: FilePath -> IO String
(define (readFile fp)
  (file->string
   (expand-user-path fp)))

; unlines :: [String] -> String
(define (unlines xs)
  (string-join xs "\n"))
