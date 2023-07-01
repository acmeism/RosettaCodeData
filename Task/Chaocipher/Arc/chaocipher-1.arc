(= lshift '((0 1) (2 14) (1 2) (14 26)))
(= rshift '((1 3) (4 15) (3 4) (15 26) (0 1)))

(= rot (fn (alpha shift)
  (let shift (mod shift 26)
    (string (cut alpha shift) (cut alpha 0 shift)))))

(= scramble-wheel (fn (alpha moves)
  (= oput '())
  (up i 0 (- (len moves) 1)
      (push (cut alpha ((moves i) 0) ((moves i) 1)) oput))
  (= oput (string (rev oput)))))

(= chaocipher (fn (left right msg (o crypted) (o dec?))
  (unless crypted
    (prn "Encoding " msg " with chaocipher")
    (prn left " " right))
  (when dec? (swap left right))
    (= offset ((positions (msg 0) right) 0))
    (= left (rot left offset))
    (= right (rot right offset))
    (push (cut left 0 1) crypted)
  (when dec? (swap left right))
  (prn (scramble-wheel left lshift)
   " " (scramble-wheel right rshift))
  (if (> (len msg) 1)
      (chaocipher (scramble-wheel left lshift)
             (scramble-wheel right rshift)
                  (cut msg 1) crypted dec?)
      (string (rev crypted)))))

(chaocipher "HXUCZVAMDSLKPEFJRIGTWOBNYQ" "PTLNBQDEOYSFAVZKGJRIHWXUMC"
            "WELLDONEISBETTERTHANWELLSAID")
(chaocipher "HXUCZVAMDSLKPEFJRIGTWOBNYQ" "PTLNBQDEOYSFAVZKGJRIHWXUMC"
            "OAHQHCNYNXTSZJRRHJBYHQKSOUJY" nil 1)
