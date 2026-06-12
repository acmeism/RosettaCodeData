(defpackage isaac
  (:use cl))

(in-package isaac)

(deftype uint32 () '(unsigned-byte 32))
(deftype arru32 () '(simple-array uint32))

(defstruct state
  (randrsl (make-array 256 :element-type 'uint32) :type arru32)
  (randcnt 0 :type uint32)
  (mm (make-array 256 :element-type 'uint32) :type arru32)
  (aa 0 :type uint32)
  (bb 0 :type uint32)
  (cc 0 :type uint32))

(defparameter *global-state* (make-state))

;; Some helper functions to force 32-bit arithmetic.
;; COERCE32 will be used to ensure the 32-bit results from
;; the given operations.
(declaim (inline lsh32 rsh32 add32 mod32 xor32))

(defmacro coerce32 (thing)
  `(ldb (byte 32 0) ,thing))

;; ASH is split into lsh32 and rsh32 to satisfy the compiler and
;; allow inlining.
(declaim (ftype (function (uint32 (unsigned-byte 6)) uint32) lsh32))
(defun lsh32 (integer count)
  (declare (optimize (speed 3) (safety 0) (space 0) (debug 0)))
  (coerce32 (ash integer count)))

(declaim (ftype (function (uint32 uint32) uint32) rsh32 add32 mod32 xor32))
(defun rsh32 (integer count)
  (declare (optimize (speed 3) (safety 0) (space 0) (debug 0)))
  (coerce32 (ash integer (- count))))

(defun add32 (x y)
  (declare (optimize (speed 3) (safety 0) (space 0) (debug 0)))
  (coerce32 (+ x y)))

(defun mod32 (number divisor)
  (declare (optimize (speed 3) (safety 0) (space 0) (debug 0)))
  (coerce32 (mod number divisor)))

(defun xor32 (x y)
  (declare (optimize (speed 3) (safety 0) (space 0) (debug 0)))
  (coerce32 (logxor x y)))

(defmacro incf32 (place &optional (delta 1))
  `(setf ,place (add32 ,place ,delta)))

(defun isaac (&optional (state *global-state*))
  "The ISAAC function."
  (declare (optimize (speed 3) (safety 0) (space 0) (debug 0))
           (type state state))
  (with-slots (randrsl randcnt mm aa bb cc) state
    (incf32 cc)
    (incf32 bb cc)
    (dotimes (i 256)
      (let ((x (aref mm i)))
        (setf aa (add32 (aref mm (mod32 (add32 i 128) 256))
                        (xor32 aa
                               (ecase (mod32 i 4)
                                 (0 (lsh32 aa 13))
                                 (1 (rsh32 aa 6))
                                 (2 (lsh32 aa 2))
                                 (3 (rsh32 aa 16))))))
        (let ((y (add32 (aref mm (mod32 (rsh32 x 2) 256))
                        (add32 aa
                               bb))))
          (setf (aref mm i) y)
          (setf bb (add32 (aref mm (mod32 (rsh32 y 10) 256))
                          x))
          (setf (aref randrsl i) bb))))
    (setf randcnt 0)
    (values)))

(defmacro mix (&rest places)
  "The magic mixer that spits out code to mix the given places."
  (let ((len (length places))
        (kernel '#0=(11 -2 8 -16 10 -4 8 -9 . #0#)))
    (rplacd (last places) places)
    `(progn
       ,@(loop
            for i from 0
            for n in kernel
            until (= i len)
            append
              (destructuring-bind (a b c d . rest) places
                (declare (ignore rest))
                (pop places)
                `((setf ,a (xor32 ,a ,(if (> n 0) `(lsh32 ,b ,n) `(rsh32 ,b ,(- n)))))
                  (incf32 ,d ,a)
                  (incf32 ,b ,c)))))))

(defun replace-tree (value replacement tree)
  "Replace all of the values in the given expression with the replacement."
  (if (atom tree)
      (if (equal tree value)
          replacement
          tree)
      (cons (replace-tree value replacement (car tree))
            (if (null (cdr tree))
                nil
                (replace-tree value replacement (cdr tree))))))

(defmacro unroller (index-name place-name places &body body)
  "A helper for unrolling a section of a loop's index with the given places."
  `(progn ,@(loop
               for place in places
               for i from 0 below (length places) append
                 `(,@(if (= i 0)
                         (replace-tree place-name place body)
                         (replace-tree index-name `(add32 ,index-name ,i)
                                       (replace-tree place-name place body)))))))

(defun randinit (flag &optional (state *global-state*))
  "Initialize the given state."
  (declare (optimize (speed 3) (safety 0) (space 0) (debug 0))
           (type state state))
  (with-slots (randrsl randcnt mm aa bb cc) state
    (let* ((a #x9e3779b9) (b a) (c a) (d a) (e a) (f a) (g a) (h a))
      (setf aa 0)
      (setf bb 0)
      (setf cc 0)
      (loop repeat 4 do
           (mix a b c d e f g h))
      (loop for idx from 0 below 256 by 8 do
           (when flag
             (unroller idx place (a b c d e f g h)
               (incf32 place (aref randrsl idx))))
           (mix a b c d e f g h)
           (unroller idx place (a b c d e f g h)
             (setf (aref mm idx) place)))
      (when flag
        (loop for idx from 0 below 256 by 8 do
             (unroller idx place (a b c d e f g h)
               (incf32 place (aref mm idx)))
             (mix a b c d e f g h)
             (unroller idx place (a b c d e f g h)
               (setf (aref mm idx) place)))))
    (isaac state)
    (setf randcnt 0)
    (values)))

(defun i-random (&optional (state *global-state*))
  "Get a random integer from the given state."
  (declare (optimize (speed 3) (safety 0) (space 0) (debug 0))
           (type state state))
  (with-slots (randrsl randcnt) state
    (prog1 (aref randrsl randcnt)
      (incf32 randcnt)
      (when (> randcnt 255)
        (isaac state)
        (setf randcnt 0)))))

(defun i-rand-a (&optional (state *global-state*))
  "Get a random printable character from the given state."
  (declare (optimize (speed 3) (safety 0) (space 0) (debug 0))
           (type state state))
  (add32 (mod32 (i-random state) 95) 32))

(defun i-seed (seed flag &optional (state *global-state*))
  "Seed the given state with a string of up to 256 characters."
  (declare (optimize (speed 3) (safety 0) (space 0) (debug 0))
           (type state state)
           (type string seed))
  (with-slots (randrsl mm) state
    (dotimes (i 256)
      (setf (aref mm i) 0))
    (let ((m (length seed)))
      (dotimes (i 256)
        (setf (aref randrsl i)
              (if (>= i m)
                  0
                  (char-code (char seed i))))))
    (randinit flag state)
    (values)))

(defun vernam (msg &optional (state *global-state*))
  "Vernam encode MSG with STATE."
  (declare (optimize (speed 3) (safety 0) (space 0) (debug 0))
           (type state state)
           (type string msg))
  (let* ((l (length msg))
         (v (make-string l)))
    (dotimes (i l)
      (setf (aref v i) (code-char (logxor (i-rand-a state) (char-code (char msg i))))))
    v))

;; Cipher modes: encipher, decipher, none
(defconstant +mod+ 95)
(defconstant +start+ 32)

(defun caesar (mode char shift modulo start)
  "Caesar encode the given character."
  (declare (optimize (speed 3) (safety 0) (space 0) (debug 0))
           (type uint32 char shift modulo start))
  (when (eq mode 'decipher)
    (setf shift (- shift)))
  (let ((n (mod (+ (- char start) shift) modulo)))
    (when (< n 0)
      (incf n modulo))
    (+ start n)))

(defun caesar-str (mode msg modulo start &optional (state *global-state*))
  "Caesar encode or decode MSG with STATE."
  (declare (optimize (speed 3) (safety 0) (space 0) (debug 0))
           (type string msg)
           (type fixnum modulo start)
           (type state state))
  (let* ((l (length msg))
         (c (make-string l)))
    (dotimes (i l)
      (setf (aref c i) (code-char (caesar mode (char-code (char msg i)) (i-rand-a state) modulo start))))
    c))

(defun print-hex (string)
  (loop for c across string do (format t "~2,'0x" (char-code c))))

(defun main-test ()
  (let ((state (make-state))
        (msg "a Top Secret secret")
        (key "this is my secret key"))
    (i-seed key t state)
    (let ((vctx (vernam msg state))
          (cctx (caesar-str 'encipher msg +mod+ +start+ state)))
      (i-seed key t state)
      (let ((vptx (vernam vctx state))
            (cptx (caesar-str 'decipher cctx +mod+ +start+ state)))
        (format t "Message: ~a~%" msg)
        (format t "Key    : ~a~%" key)
        (format t "XOR    : ")
        (print-hex vctx)
        (terpri)
        (format t "XOR dcr: ~a~%" vptx)
        (format t "MOD    : ")
        (print-hex cctx)
        (terpri)
        (format t "MOD dcr: ~a~%" cptx))))
  (values))
