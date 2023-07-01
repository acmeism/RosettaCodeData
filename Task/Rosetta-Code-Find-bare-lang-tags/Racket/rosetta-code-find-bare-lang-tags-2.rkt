(define (get-category cat)
  (let loop ([c #f])
    (define t
      ((compose1 read-json get-pure-port string->url format)
       "http://rosettacode.org/mw/api.php?~a"
       (alist->form-urlencoded
        `([list . "categorymembers"] [cmtitle . ,(format "Category:~a" cat)]
          [cmcontinue . ,(and c (dict-ref c 'cmcontinue))]
          [cmlimit . "500"] [format . "json"] [action . "query"]))))
    (define (c-m key) (dict-ref (dict-ref t key '()) 'categorymembers #f))
    (append (for/list ([page (c-m 'query)]) (dict-ref page 'title))
            (cond [(c-m 'query-continue) => loop] [else '()]))))

(for ([page (get-category "Programming Tasks")])
  (printf "Page: ~a " page)
  (find-bare-tags page))
