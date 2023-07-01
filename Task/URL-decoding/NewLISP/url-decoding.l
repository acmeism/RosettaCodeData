;; universal decoder, works for ASCII and UTF-8
;; (source http://www.newlisp.org/index.cgi?page=Code_Snippets)
(define (url-decode url (opt nil))
  (if opt (replace "+" url " "))
  (replace "%([0-9a-f][0-9a-f])" url (pack "b" (int $1 0 16)) 1))

(url-decode "http%3A%2F%2Ffoo%20bar%2F")
