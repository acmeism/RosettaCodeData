(use srfi-42)

(define ages '((27 Jonah) (18 Alan) (28 Glory) (18 Popeye) (28 Alan)))

(define nemeses '((Jonah Whales) (Jonah Spiders) (Alan Ghosts)
                  (Alan Zombies) (Glory Buffy)
                  (unknown nothing)))

(define hash (make-hash-table 'equal?))

(dolist (item ages)
  (hash-table-push! hash (last item) (car item)))

(do-ec
  (: person nemeses)
  (:let name (car person))
  (if (hash-table-exists? hash name))
  (: age (~ hash name))
  (print (list (list age name)
               person)))
