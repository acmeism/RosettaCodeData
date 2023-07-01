(let ((keys ["a" "b" "c"])
      (values [1 2 3]))
  (apply 'vector (cl-loop for i across keys for j across values collect (vector i j))))
