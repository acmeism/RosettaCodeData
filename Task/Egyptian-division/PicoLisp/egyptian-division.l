(seed (in "/dev/urandom" (rd 8)))

(de divmod (Dend Disor)
   (cons (/ Dend Disor) (% Dend Disor)) )
(de egyptian (Dend Disor)
   (let
      (P 0
         D Disor
         S
         (make
            (while (>= Dend (setq @@ (+ D D)))
               (yoke
                  (cons
                     (** 2 (swap 'P (inc P)))
                     (swap 'D @@) ) ) ) )
         P (** 2 P) )
      (mapc
         '((L)
            (and
               (>= Dend (+ D (cdr L)))
               (inc 'P (car L))
               (inc 'D (cdr L)) ) )
         S )
      (cons P (abs (- Dend D))) ) )
(for N 1000
   (let (A (rand 1 1000)  B (rand 1 A))
      (test (divmod A B) (egyptian A B)) ) )
(println (egyptian 580 34))
