`(== 64 64)
(seed (in "/dev/urandom" (rd 8)))
(scl 20)
(de gridX (X)
   (*/ (+ 320.0 (*/ X 58.18 1.0)) 1.0) )
(de gridY (Y)
   (*/ (- 640.0 (*/ Y 58.18 1.0)) 1.0) )
(de calc (R X Y)
   (cond
      ((< R 1) (list 0 (*/ Y 0.16 1.0)))
      ((< R 86)
         (list
            (+ (*/ 0.85 X 1.0) (*/ 0.04 Y 1.0))
            (+ (*/ -0.04 X 1.0) (*/ 0.85 Y 1.0) 1.6) ) )
      ((< R 93)
         (list
            (- (*/ 0.2 X 1.0) (*/ 0.26 Y 1.0))
            (+ (*/ 0.23 X 1.0) (*/ 0.22 Y 1.0) 1.6) ) )
      (T
         (list
            (+ (*/ -0.15 X 1.0) (*/ 0.28 Y 1.0))
            (+ (*/ 0.26 X 1.0) (*/ 0.24 Y 1.0) 0.44) ) ) ) )
(let
   (X 0
      Y 0
      G (make (do 640 (link (need 640 0)))) )
   (do 100000
      (let ((A B) (calc (rand 0 99) X Y))
         (setq X A  Y B)
         (set (nth G (gridY Y) (gridX X)) 1) ) )
   (out "fern.pbm"
      (prinl "P1")
      (prinl 640 " " 640)
      (mapc prinl G) ) )
