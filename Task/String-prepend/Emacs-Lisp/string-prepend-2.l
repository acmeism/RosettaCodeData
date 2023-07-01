(require 'cl-lib)

(defvar str "bar")
(cl-callf2 concat "foo" str)
str ;=> "foobar"
