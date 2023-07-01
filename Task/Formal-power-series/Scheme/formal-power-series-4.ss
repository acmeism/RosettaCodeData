(display (take 10 (fps+ (fps* fpssin fpssin) (fps* fpscos fpscos))))
(newline)

(define fpstan
  (fps/ fpssin fpscos))

(display (take 10 fpstan))
(newline)
