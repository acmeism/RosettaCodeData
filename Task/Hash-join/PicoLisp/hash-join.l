(de A
   (27 . Jonah)
   (18 . Alan)
   (28 . Glory)
   (18 . Popeye)
   (28 . Alan) )

(de B
   (Jonah . Whales)
   (Jonah . Spiders)
   (Alan . Ghosts)
   (Alan . Zombies)
   (Glory . Buffy) )

(for X B
   (let K (cons (char (hash (car X))) (car X))
      (if (idx 'M K T)
         (push (caar @) (cdr X))
         (set (car K) (list (cdr X))) ) ) )

(for X A
   (let? Y (car (idx 'M (cons (char (hash (cdr X))) (cdr X))))
      (for Z (caar Y)
         (println (car X) (cdr X) (cdr Y) Z) ) ) )
