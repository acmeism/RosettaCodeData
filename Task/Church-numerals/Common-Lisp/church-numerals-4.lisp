(defmacro church-if (test then else)
  `(funcall ,test (lambda () ,then) (lambda () ,else)))

(defvar true (lambda (f g) (funcall f)))
(defvar false (lambda (f g) (funcall g)))
