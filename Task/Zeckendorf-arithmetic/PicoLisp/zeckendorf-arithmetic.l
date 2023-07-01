(seed (in "/dev/urandom" (rd 8)))

(de unpad (Lst)
   (while (=0 (car Lst))
      (pop 'Lst) )
   Lst )

(de numz (N)
   (let Fibs (1 1)
      (while (>= N (+ (car Fibs) (cadr Fibs)))
         (push 'Fibs (+ (car Fibs) (cadr Fibs))) )
      (make
         (for I (uniq Fibs)
            (if (> I N)
               (link 0)
               (link 1)
               (dec 'N I) ) ) ) ) )

(de znum (Lst)
   (let Fibs (1 1)
      (do (dec (length Lst))
         (push 'Fibs (+ (car Fibs) (cadr Fibs))) )
      (sum
         '((X Y) (unless (=0 X) Y))
         Lst
         (uniq Fibs) ) ) )

(de incz (Lst)
   (addz Lst (1)) )

(de decz (Lst)
   (subz Lst (1)) )

(de addz (Lst1 Lst2)
   (let Max (max (length Lst1) (length Lst2))
      (reorg
         (mapcar + (need Max Lst1 0) (need Max Lst2 0)) ) ) )

(de subz (Lst1 Lst2)
   (use (@A @B)
      (let
         (Max (max (length Lst1) (length Lst2))
            Lst (mapcar - (need Max Lst1 0) (need Max Lst2 0)) )
         (loop
            (while (match '(@A 1 0 0 @B) Lst)
               (setq Lst (append @A (0 1 1) @B)) )
            (while (match '(@A 1 -1 0 @B) Lst)
               (setq Lst (append @A (0 0 1) @B)) )
            (while (match '(@A 1 -1 1 @B) Lst)
               (setq Lst (append @A (0 0 2) @B)) )
            (while (match '(@A 1 0 -1 @B) Lst)
               (setq Lst (append @A (0 1 0) @B)) )
            (while (match '(@A 2 0 0 @B) Lst)
               (setq Lst (append @A (1 1 1) @B)) )
            (while (match '(@A 2 -1 0 @B) Lst)
               (setq Lst (append @A (1 0 1) @B)) )
            (while (match '(@A 2 -1 1 @B) Lst)
               (setq Lst (append @A (1 0 2) @B)) )
            (while (match '(@A 2 0 -1 @B) Lst)
               (setq Lst (append @A (1 1 0) @B)) )
            (while (match '(@A 1 -1) Lst)
               (setq Lst (append @A (0 1))) )
            (while (match '(@A 2 -1) Lst)
               (setq Lst (append @A (1 1))) )
            (NIL (match '(@A -1 @B) Lst)) )
         (reorg (unpad Lst)) ) ) )

(de mulz (Lst1 Lst2)
   (let (Sums (list Lst1) Mulz (0))
      (mapc
         '((X)
            (when (= 1 (car X))
               (setq Mulz (addz (cdr X) Mulz)) )
            Mulz )
         (mapcar
            '((X)
               (cons
                  X
                  (push 'Sums (addz (car Sums) (cadr Sums))) ) )
            (reverse Lst2) ) ) ) )

(de divz (Lst1 Lst2)
   (let Q 0
      (while (lez Lst2 Lst1)
         (setq Lst1 (subz Lst1 Lst2))
         (setq Q (incz Q)) )
      (list Q (or Lst1 (0))) ) )

(de reorg (Lst)
   (use (@A @B)
      (let Lst (reverse Lst)
         (loop
            (while (match '(@A 1 1 @B) Lst)
               (if @B
                  (inc (nth @B 1))
                  (setq @B (1)) )
               (setq Lst (append @A (0 0) @B) ) )
            (while (match '(@A 2 @B) Lst)
               (inc
                  (if (cdr @A)
                     (tail 2 @A)
                     @A ) )
               (if @B
                  (inc (nth @B 1))
                  (setq @B (1)) )
               (setq Lst (append @A (0) @B)) )
            (NIL
               (or
                  (match '(@A 1 1 @B) Lst)
                  (match '(@A 2 @B) Lst) ) ) )
         (reverse Lst) ) ) )

(de lez (Lst1 Lst2)
   (let Max (max (length Lst1) (length Lst2))
      (<= (need Max Lst1 0) (need Max Lst2 0)) ) )

(let (X 0 Y 0)
   (do 1024
      (setq X (rand 1 1024))
      (setq Y (rand 1 1024))
      (test (numz (+ X Y)) (addz (numz X) (numz Y)))
      (test (numz (* X Y)) (mulz (numz X) (numz Y)))
      (test (numz (+ X 1)) (incz (numz X))) )

   (do 1024
      (setq X (rand 129 1024))
      (setq Y (rand 1 128))
      (test (numz (- X Y)) (subz (numz X) (numz Y)))
      (test (numz (/ X Y)) (car (divz (numz X) (numz Y))))
      (test (numz (% X Y)) (cadr (divz (numz X) (numz Y))))
      (test (numz (- X 1)) (decz (numz X))) ) )

(bye)
