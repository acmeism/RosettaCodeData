(defstruct stack
  elements)

(defun stack-push (element stack)
  (push element (stack-elements stack)))

(defun stack-pop (stack)(deftype Stack [elements])

(defun stack-empty (stack)
  (endp (stack-elements stack)))

(defun stack-top (stack)
  (first (stack-elements stack)))

(defun stack-peek (stack)
  (stack-top stack))
