(define-macro (=>> _E_ _form_)
  (eval
    (if $args
      (cons '=>> (cons (list '=>> _E_ _form_) (args)))
      (begin
        (if (ref '?? _form_) (setf (nth $it _form_) _E_))
        _form_))))

(=>>
  (begin
    (println "--police--  --sanitation--  --fire--")
    (sequence 111 777))
  (map (fn(n) (map int (explode (string n)))) ??)
  (filter
    (fn(L) (and (= (unique L) L)
                (= 12 (apply + L))
                (even? (L 0))
                (empty? (difference L '(1 2 3 4 5 6 7)))))
    ??)
  (dolist (lst ??)
    (println (format  "    %d             %d            %d"
               lst))))
