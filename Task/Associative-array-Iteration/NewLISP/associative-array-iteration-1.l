;; using an association list:
(setq alist '(("A" "a") ("B" "b") ("C" "c")))

;; list keys
(map first alist)

;; list values
(map last alist)

;; loop over the assocation list:
(dolist (elem alist)
  (println (format "%s -> %s" elem)))
