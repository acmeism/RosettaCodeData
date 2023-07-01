#lang racket

(require net/url net/uri-codec json)

(define (get-text page)
  (define ((get k) x) (dict-ref x k))
  ((compose1 (get '*) car (get 'revisions) cdar hash->list (get 'pages)
             (get 'query) read-json get-pure-port string->url format)
   "http://rosettacode.org/mw/api.php?~a"
   (alist->form-urlencoded
    `([titles . ,page] [prop . "revisions"] [rvprop . "content"]
      [format . "json"] [action . "query"]))))

(define (find-bare-tags page)
  (define in (open-input-string (get-text page)))
  (define rx
    ((compose1 pregexp string-append)
     "<\\s*lang\\s*>|"
     "==\\s*\\{\\{\\s*header\\s*\\|\\s*([^{}]*?)\\s*\\}\\}\\s*=="))
  (let loop ([lang "no language"] [bare '()])
    (match (regexp-match rx in)
      [(list _ #f) (loop lang (dict-update bare lang add1 0))]
      [(list _ lang) (loop lang bare)]
      [#f (if (null? bare) (printf "no bare language tags\n")
              (begin (printf "~a bare language tags\n" (apply + (map cdr bare)))
                     (for ([b bare]) (printf "  ~a in ~a\n" (cdr b) (car b)))))])))

(find-bare-tags "Rosetta Code/Find bare lang tags")
