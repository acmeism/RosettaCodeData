(defun wrap-text (text)
  (wrap-text text 78))

(defun wrap-text (text max-len)
  (string:join
    (make-wrapped-lines
      (string:tokens text " ") max-len)
    "\n"))

(defun make-wrapped-lines
  (((cons word rest) max-len)
    (let ((`#(,_ ,_ ,last-line ,lines) (assemble-lines max-len word rest)))
      (lists:reverse (cons last-line lines)))))

(defun assemble-lines (max-len word rest)
  (lists:foldl
    #'assemble-line/2
    `#(,max-len ,(length word) ,word ())
    rest))

(defun assemble-line
  ((word `#(,max ,line-len ,line ,acc)) (when (> (+ (length word) line-len) max))
    `#(,max ,(length word) ,word ,(cons line acc)))
  ((word `#(,max ,line-len ,line ,acc))
    `#(,max ,(+ line-len 1 (length word)) ,(++ line " " word) ,acc)))
