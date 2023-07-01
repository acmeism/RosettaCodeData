;; CLISP puts the external formats into a separate package
#+clisp (import 'charset:utf-8 'keyword)

(with-open-file (s "input.txt" :external-format :utf-8)
  (loop for c = (read-char s nil)
        while c
        do (format t "~a" c)))
