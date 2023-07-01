(version)
→ EchoLisp - 2.50.3
  📗 local-db: db.version: 3

(when (< (version) 2.6)
  (writeln "Please reload EchoLisp : CTRL-F5, CMD-R or other...")
  (exit))

(if (and (bound? 'bloop) (bound? 'abs) (procedure? abs))
    (abs bloop) 'NOT-HERE)
    → NOT-HERE

(define bloop -777)
   → bloop
(if (and (bound? 'bloop) (bound? 'abs) (procedure? abs)) (abs bloop) 'NOT-HERE)
   → 777

(for/sum ((kv (environment-bindings user-initial-environment )))
    #:when (integer? (second kv))
    (writeln kv)
    (second kv))

    ("bloop" -777)
    ("gee" 555)
    ("buzz" 333)
    → 111 ;; sum
