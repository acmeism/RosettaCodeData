;; find common prefix of two strings
(define (prefix s t ) (for/string ((u s) (v t)) #:break (not (= u v)) u))

(prefix "foo" "foobar") → "foo"

;; fold over a list of strings
(define (lcp strings)
	(if
	(null? strings) ""
	(foldl prefix (first strings) (rest strings))))

 define lcp-test '(
 ("interspecies" "interstellar" "interstate")
 ("throne" "throne")
 ("throne" "dungeon")
 ("cheese")
 ("")
 ()
 ("prefix" "suffix")))

;;
(for ((t lcp-test)) (writeln t '→ (lcp t)))
    ("interspecies" "interstellar" "interstate")    →     "inters"
    ("throne" "throne")     →    "throne"
    ("throne" "dungeon")     →     ""
    ("cheese")     →     "cheese"
    ("")     →     ""
    null     →     ""
    ("prefix" "suffix")     →     ""

