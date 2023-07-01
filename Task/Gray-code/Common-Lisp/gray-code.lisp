(defun gray-encode (n)
  (logxor n (ash n -1)))

(defun gray-decode (n)
  (do ((p n (logxor p n)))
    ((zerop n) p)
    (setf n (ash n -1))))

(loop for i to 31 do
      (let* ((g (gray-encode i)) (b (gray-decode g)))
	(format t "~2d:~6b =>~6b =>~6b :~2d~%" i i g b b)))
