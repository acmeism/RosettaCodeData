(tc +)

(datatype subtype
  (subtype B A); X : B;
  _____________________
  X : A;)

(datatype integer
  if (integer? X)
  ___________
  X: integer;

  ________________________
  (subtype integer number);)

(datatype bit
  if (< X 2)
  _______
  X: bit;

  _____________________
  (subtype bit integer);)

(datatype row

  _________
  [] : row;

  C : bit; Row : row;
  ===================
  [C | Row] : row;)

(datatype universe

  ______________
  [] : universe;

  R : row; Uni : universe;
  ========================
  [R | Uni] : universe;)

(define conway-nth
  \\ returns value of x from row if it exists, else 0
  { number --> row --> bit }
  _ [] -> 0
  N _ -> 0 where (< N 0)
  0 [A|B] -> A
  N [A|B] -> (conway-nth (- N 1) B))

(define row-retrieve
  { number --> universe --> row }
  _ [] -> []
  0 [] -> []
  0 [A|B] -> A
  N [A|B] -> (row-retrieve (- N 1) B))

(define cell-retrieve
  { number --> number --> universe --> bit }
  X Y Universe -> (conway-nth X (row-retrieve Y Universe)))

(define neighbors
  \\ takes an X and Y, retrieves the number of neighbors
  { number --> number --> universe --> number }
  X Y Universe -> (let ++ (+ 1)
                       -- (/. X (- X 1))
                    (+ (cell-retrieve (++ X) Y Universe)
                       (cell-retrieve (++ X) (++ Y) Universe)
                       (cell-retrieve (++ X) (-- Y) Universe)
                       (cell-retrieve (-- X) Y Universe)
                       (cell-retrieve (-- X) (++ Y) Universe)
                       (cell-retrieve (-- X) (-- Y) Universe)
                       (cell-retrieve X (++ Y) Universe)
                       (cell-retrieve X (-- Y) Universe))))

(define handle-alive
  { number --> number --> universe --> bit }
  X Y Universe -> (if (or (= (neighbors X Y Universe) 2)
                          (= (neighbors X Y Universe) 3))
                      1 0))

(define handle-dead
  { number --> number --> universe --> bit }
  X Y Universe -> (if (= (neighbors X Y Universe) 3)
                      1 0))

(define next-row
  \\ first argument must be a previous row, second must be 0 when
  \\ first called, third must be a Y value and the final must be the
  \\ current universe
  { row --> number --> number --> universe --> row }
  [] _ _ _ -> []
  [1|B] X Y Universe -> (cons (handle-alive X Y Universe)
                              (next-row B (+ X 1) Y Universe))
  [_|B] X Y Universe -> (cons (handle-dead X Y Universe)
                              (next-row B (+ X 1) Y Universe)))

(define next-universe
  \\ both the first and second arguments must be the same universe,
  \\ the third must be 0 upon first call
  { universe --> number --> universe --> universe }
  [] _ _ -> []
  [Row|Rest] Y Universe -> (cons (next-row Row 0 Y Universe)
                                 (next-universe Rest (+ Y 1) Universe)))

(define display-row
  { row --> number }
  [] -> (nl)
  [1|Rest] -> (do (output "* ")
                  (display-row Rest))
  [_|Rest] -> (do (output "  ")
                  (display-row Rest)))

(define display-universe
  { universe --> number }
  [] -> (nl 2)
  [Row|Rest] -> (do (display-row Row)
                    (display-universe Rest)))

(define iterate-universe
  { number --> universe --> number }
  0 _ -> (nl)
  N Universe -> (do (display-universe Universe)
                    (iterate-universe (- N 1)
                                      (next-universe Universe 0 Universe))))

(iterate-universe
 10
 [[0 0 0 0 0 0]
  [0 0 0 0 0 0]
  [0 0 1 1 1 0]
  [0 1 1 1 0 0]
  [0 0 0 0 0 0]
  [0 0 0 0 0 0]])
