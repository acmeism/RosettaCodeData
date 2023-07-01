(defun my-getenv (name &optional default)
  #+CMU
  (let ((x (assoc name ext:*environment-list*
                  :test #'string=)))
    (if x (cdr x) default))
  #-CMU
  (or
    #+Allegro (sys:getenv name)
    #+CLISP (ext:getenv name)
    #+ECL (si:getenv name)
    #+SBCL (sb-unix::posix-getenv name)
    #+ABCL (getenv name)
    #+LISPWORKS (lispworks:environment-variable name)
    default))

(if (not ( null (remove-if #'null (mapcar #'my-getenv '("LANG" "LC_ALL" "LC_CTYPE")))))
  (format t "Unicode is supported on this terminal and U+25B3 is : ~a~&" (code-char #x25b3))
  (format t "Unicode is not supported on this terminal.~&")
  )
