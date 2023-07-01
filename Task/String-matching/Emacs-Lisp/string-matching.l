(defun string-contains (needle haystack)
  (string-match (regexp-quote needle) haystack))

(string-prefix-p "before" "before center after") ;=> t
(string-contains "before" "before center after") ;=> 0
(string-suffix-p "before" "before center after") ;=> nil

(string-prefix-p "center" "before center after") ;=> nil
(string-contains "center" "before center after") ;=> 7
(string-suffix-p "center" "before center after") ;=> nil

(string-prefix-p "after" "before center after") ;=> nil
(string-contains "after" "before center after") ;=> 14
(string-suffix-p "after" "before center after") ;=> t
