$ rlwrap sbcl
This is SBCL 1.0.25, an implementation of ANSI Common Lisp.
More information about SBCL is available at <http://www.sbcl.org/>.
...
* (defun f (string-1 string-2 separator)
    (concatenate 'string string-1 separator separator string-2))

F
* (f "Rosetta" "Code" ":")

"Rosetta::Code"
*
