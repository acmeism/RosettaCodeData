(require 'cl-lib)

(defvar str "foo")
(cl-callf concat str "bar")
str ;=> "foobar"
