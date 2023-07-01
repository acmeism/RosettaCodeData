;; a random length list of random values
(define L (map random (make-list (random 50) 100))) → L
L → (24 60 83 8 24 60 31 97 96 65 9 41 64 24 22 57 73 17 6 28 77 58 18 13 27 22 41 69 85)

;; find max
(apply max L) → 97
