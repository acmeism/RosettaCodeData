(scl 24)

(setq *Shades
  (list "." ":" "!" "*" "o" "e" "&" "#" "%" "@"))

(setq *Light
  (list 30.0 30.0 -50.0))

(de normalize (V)
  (let Len
    (sqrt
      (sum
        (quote (X)
          (** X 2))
        V))
    (mapcar
      (quote (X)
        (*/ X 1.0 Len))
      V)))

(de dot (X Y)
  (let D (sum (quote (A B) (*/ A B 1.0)) X Y)
    (if (< D 0) (- D) 0)))

(de floor (N)
  (* 1.0 (*/ (- N 0.5) 1.0)))

(de ceil (N)
  (* 1.0 (*/ (+ N 0.5) 1.0)))

(de drawSphere (R K Ambient)
  (let Vec NIL
    (for (I (floor (- R)) (<= I (ceil R)) (+ I 1.0))
      (let X (+ I 0.5)
        (for (J (floor (* -2 R)) (<= J (ceil (* 2 R))) (+ J 1.0))
          (let Y (+ (/ J 2) 0.5)
            (if (<= (+ (*/ X X 1.0) (*/ Y Y 1.0)) (*/ R R 1.0))
              (prog
                (setq Vec
                  (list X Y
                    (sqrt
                      (* 1.0
                        (- (*/ R R 1.0)
                           (*/ X X 1.0)
                           (*/ Y Y 1.0))))))
                (setq Vec (normalize Vec))
                (let (B NIL
                      Intensity NIL)
                  (setq B (+ (/ (** (dot *Light Vec) K) (** 1.0 (- K 1))) Ambient))
                  (setq Intensity
                    (if (<= B 0)
                      (- (length *Shades) 2)
                      (max (format (round (*/ (- 1.0 B) (* (- (length *Shades) 1) 1.0) 1.0) 0)) 0)))
                  (prin (nth *Shades (+ Intensity 1) 1))))
              (prin " "))))
        (prinl)))))

(setq *Light (normalize *Light))
(drawSphere 20.0 4 0.1)
(drawSphere 10.0 2 0.4)
