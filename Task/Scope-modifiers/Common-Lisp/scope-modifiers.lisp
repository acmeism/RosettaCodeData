;; *bug* shall have a dynamic binding.
(declaim (special *bug*))

(let ((shape "triangle") (*bug* "ant"))
  (flet ((speak ()
           (format t "~%  There is some ~A in my ~A!" *bug* shape)))
    (format t "~%Put ~A in your ~A..." *bug* shape)
    (speak)

    (let ((shape "circle") (*bug* "cockroach"))
      (format t "~%Put ~A in your ~A..." *bug* shape)
      (speak))))
