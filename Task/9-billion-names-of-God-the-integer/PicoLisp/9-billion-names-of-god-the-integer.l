(de row (N)
   (let C '((1))
      (do N
         (push 'C (grow C)) )
      (mapcon
         '((L)
            (when (cdr L)
               (cons (- (cadr L) (car L))) ) )
         (car C) ) ) )

(de grow (Lst)
   (let (L (length Lst)  S 0)
      (cons
         0
         (mapcar
            '((I X)
               (inc 'S
                  (get I (inc (min X (- L X)))) ) )
            Lst
            (range 1 L) ) ) ) )

(de sumr (N)
   (let
      (K 1
         S 1
         O (cons 1 (need N 0))
         D
         (make
            (while
               (<
                  (* K (dec (* 3 K)))
                  (* 2 N) )
               (link (list (dec (* 2 K)) S))
               (link (list K S))
               (inc 'K)
               (setq S (- S)) ) ) )
      (for (Y O (cdr Y) (cdr Y))
         (let Z Y
            (for L D
               (inc
                  (setq Z (cdr (nth Z (car L))))
                  (* (car Y) (cadr L)) ) ) ) )
      (last O) ) )

(for I 25
   (println (row I)) )

(bench
   (for I '(23 123 1234 12345)
      (println (sumr I)) ) )

(bye)
