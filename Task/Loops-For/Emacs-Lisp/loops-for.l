;; Lisp implementation of c-for is like:
;; (let ((i nil))
;;   (while (progn (setq i (if (not i) 0 (1+ i) )) ;; if value of i is nil, initialize its value to 0, if else, add 1
;; 		(< i 10))                       ;; end loop when i > 10
;;     (... body ...) ) )                          ;; loop body

(let ((i nil) (str ""))
  (while (progn (setq i (if (not i) 0 (1+ i) ))
		(< i 5))
    (setq str (concat str "*"))
    (message str) ) )
