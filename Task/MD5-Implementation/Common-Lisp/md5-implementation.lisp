(defpackage #:md5
  (:use #:cl))

(in-package #:md5)

(require :babel)

(deftype word () '(unsigned-byte 32))
(deftype octet () '(unsigned-byte 8))
(deftype octets () '(vector octet))

(defparameter *s*
  (make-array 16 :element-type 'word
                 :initial-contents '(7 12 17 22
                                     5  9 14 20
                                     4 11 16 23
                                     6 10 15 21)))

(defun s (i)
  (declare ((integer 0 63) i))
  (aref *s* (+ (ash (ash i -4) 2)
               (ldb (byte 2 0) i))))

(defparameter *k*
  (loop with result = (make-array 64 :element-type 'word)
        for i from 0 below 64
        do (setf (aref result i) (floor (* (ash 1 32) (abs (sin (1+ (float i 1d0)))))))
        finally (return result)))

(defun wrap (bits integer)
  (declare (fixnum bits) (integer integer))
  (ldb (byte bits 0) integer))

(defun integer->8octets (integer)
  (declare (integer integer))
  (loop for n = (wrap 64 integer) then (ash n -8)
        repeat 8
        collect (wrap 8 n)))

(defun pad-octets (octets)
  (declare (octets octets))
  (let* ((octets-length (length octets))
         (zero-pad-length (- 64 (mod (+ octets-length 9) 64)))
         (zero-pads (loop repeat zero-pad-length collect 0)))
    (concatenate 'octets octets '(#x80) zero-pads (integer->8octets (* 8 octets-length)))))

(defun octets->words (octets)
  (declare (octets octets))
  (loop with result = (make-array (/ (length octets) 4) :element-type 'word)
        for n from 0 below (length octets) by 4
        for i from 0
        do (setf (aref result i)
                 (dpb (aref octets (+ n 3)) (byte 8 24)
                      (dpb (aref octets (+ n 2)) (byte 8 16)
                           (dpb (aref octets (1+ n)) (byte 8 8)
                                (dpb (aref octets n) (byte 8 0) 0)))))
        finally (return result)))

(defun words->octets (&rest words)
  (loop for word of-type word in words
        collect (ldb (byte 8 0)  word)
        collect (ldb (byte 8 8)  word)
        collect (ldb (byte 8 16) word)
        collect (ldb (byte 8 24) word)))

(defun left-rotate (x c)
  (declare (integer x) (fixnum c))
  (let ((x (wrap 32 x)))
    (wrap 32 (logior (ash x c)
                     (ash x (- c 32))))))

(defun md5 (string)
  (declare (string string))
  (loop with m = (octets->words (pad-octets (babel:string-to-octets string)))
        with a0 of-type word = #x67452301
        with b0 of-type word = #xefcdab89
        with c0 of-type word = #x98badcfe
        with d0 of-type word = #x10325476
        for j from 0 below (length m) by 16
        do (loop for a of-type word = a0 then d
                 and b of-type word = b0 then new-b
                 and c of-type word = c0 then b
                 and d of-type word = d0 then c
                 for i from 0 below 64
                 for new-b = (multiple-value-bind (f g)
                                 (ecase (ash i -4)
                                   (0 (values (wrap 32 (logior (logand b c)
                                                               (logand (lognot b) d)))
                                              i))
                                   (1 (values (wrap 32 (logior (logand d b)
                                                               (logand (lognot d) c)))
                                              (wrap 4 (1+ (* 5 i)))))
                                   (2 (values (wrap 32 (logxor b c d))
                                              (wrap 4 (+ (* 3 i) 5))))
                                   (3 (values (wrap 32 (logxor c
                                                               (logior b (lognot d))))
                                              (wrap 4 (* 7 i)))))
                               (declare (word f g))
                               (wrap 32 (+ b (left-rotate (+ a f (aref *k* i) (aref m (+ j g)))
                                                          (s i)))))
                 finally (setf a0 (wrap 32 (+ a0 a))
                               b0 (wrap 32 (+ b0 b))
                               c0 (wrap 32 (+ c0 c))
                               d0 (wrap 32 (+ d0 d))))
        finally (return (with-output-to-string (s)
                          (dolist (o (words->octets a0 b0 c0 d0))
                            (format s "~(~2,'0X~)" o))))))

(defun test-cases ()
  (assert (string= "d41d8cd98f00b204e9800998ecf8427e"
                   (md5 "")))
  (assert (string= "0cc175b9c0f1b6a831c399e269772661"
                   (md5 "a")))
  (assert (string= "900150983cd24fb0d6963f7d28e17f72"
                   (md5 "abc")))
  (assert (string= "f96b697d7cb7938d525a2f31aaf161d0"
                   (md5 "message digest")))
  (assert (string= "c3fcd3d76192e4007dfb496cca67e13b"
                   (md5 "abcdefghijklmnopqrstuvwxyz")))
  (assert (string= "d174ab98d277d9f5a5611c2c9f419d9f"
                   (md5 "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789")))
  (assert (string= "57edf4a22be3c955ac49da2e2107b67a"
                   (md5 "12345678901234567890123456789012345678901234567890123456789012345678901234567890"))))
