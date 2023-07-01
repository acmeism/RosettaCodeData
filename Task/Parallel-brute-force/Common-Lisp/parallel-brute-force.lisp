(defpackage #:parallel-brute-force
  (:use #:cl
        #:lparallel))

(in-package #:parallel-brute-force)

(defparameter *alphabet* "abcdefghijklmnopqrstuvwxyz")
(defparameter *hash0* "1115dd800feaacefdf481f1f9070374a2a81e27880f187396db67958b207cbad")
(defparameter *hash1* "3a7bd3e2360a3d29eea436fcfb7e44c735d117c42d1c1835420b6b9942dd4f1b")
(defparameter *hash2* "74e1bb62f8dabb8125a58852b63bdf6eaef667cb56ac7f7cdba6d7305c50a22f")
(defparameter *kernel-size* 7)

(defun sha-256 (input)
  (ironclad:byte-array-to-hex-string
   (ironclad:digest-sequence :sha256 (ironclad:ascii-string-to-byte-array input))))

(defun call-with-5-char-string (fun first-char)
  (loop with str = (make-array 5 :element-type 'character :initial-element first-char)
        for c1 across *alphabet*
        do (setf (char str 1) c1)
           (loop for c2 across *alphabet*
                 do (setf (char str 2) c2)
                    (loop for c3 across *alphabet*
                          do (setf (char str 3) c3)
                             (loop for c4 across *alphabet*
                                   do (setf (char str 4) c4)
                                      (funcall fun (copy-seq str)))))))

(defmacro with-5-char-string ((str first-char) &body body)
  `(call-with-5-char-string (lambda (,str) ,@body) ,first-char))

(defun find-passwords-with (first-char)
  (let (results)
    (with-5-char-string (str first-char)
      (let ((hash (sha-256 str)))
        (when (or (string= hash *hash0*) (string= hash *hash1*) (string= hash *hash2*))
          (push (list str hash) results))))
    (nreverse results)))

(defun find-passwords ()
  (setf *kernel* (make-kernel *kernel-size*))
  (let ((results (unwind-protect
                      (pmapcan #'find-passwords-with *alphabet*)
                   (end-kernel))))
    (dolist (r results)
      (format t "~A: ~A~%" (first r) (second r)))))
