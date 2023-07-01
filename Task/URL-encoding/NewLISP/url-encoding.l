;; simple encoder
;; (source http://www.newlisp.org/index.cgi?page=Code_Snippets)
(define (url-encode str)
  (replace {([^a-zA-Z0-9])} str (format "%%%2X" (char $1)) 0))

(url-encode "http://foo bar/")
