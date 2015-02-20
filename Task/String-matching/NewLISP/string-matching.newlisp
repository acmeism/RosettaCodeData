(setq str "abcdefbcghi")

;; test if str starts with "ab"
(starts-with str "ab")

;; find "bc" inside str
(find "bc" str)

;; test if str ends with "ghi"
(ends-with str "ghi")

;; find all positions of pattern inside str
(define (find-all-pos pattern str)
  (let ((idx -1) (pos '()))
    (while (setq idx (find pattern str 0 (+ idx 1)))
      (push idx pos -1))))

(find-all-pos "bc" str)
