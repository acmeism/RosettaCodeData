(define fpscos
  (fps- (lons 1 (repeat 0)) (fpsint (delay (force fpssin)))))

(define fpssin
  (fpsint (delay (force fpscos))))

(display (take 10 fpssin))
(newline)

(display (take 10 fpscos))
(newline)
