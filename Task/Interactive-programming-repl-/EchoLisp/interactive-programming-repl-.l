;; screen copy of the REPL
;; note that the &i variables remember expression evaluation, and may be used in other expressions

EchoLisp - 2.16.2
📗 local-db: db.version: 3
(define ( f s1 s2 s3) (string-append s1 s3 s3 s2))
[0]→ f
(f "Rosetta" "Code" ":")
[1]→ "Rosetta::Code"
(+ 4 8)
[2]→ 12
(* 4 8)
[3]→ 32
(* &2 &3)
[4]→ 384
(f &1 &1 ":")
[5]→ "Rosetta::Code::Rosetta::Code"

;; etc.
