;;;; This is a revised version, inspired by a throwaway script originally
;;;; published at http://deedbot.org/bundle-381528.txt by the same Adlai.

;;; package definition
(cl:defpackage :bitcoin-address-encoder
  (:use :cl . #.(ql:quickload :ironclad))
  (:shadowing-import-from :ironclad #:null)
  (:import-from :ironclad #:simple-octet-vector))
(cl:in-package :bitcoin-address-encoder)

;;; secp256k1, as shown concisely in https://en.bitcoin.it/wiki/Secp256k1
;;; and officially defined by the SECG at http://www.secg.org/sec2-v2.pdf
(macrolet ((define-constants (&rest constants)
             `(progn ,@(loop for (name value) on constants by #'cddr
                          collect `(defconstant ,name ,value)))))
  (define-constants
    ;; these constants are only necessary for computing public keys
    xg #x79BE667EF9DCBBAC55A06295CE870B07029BFCDB2DCE28D959F2815B16F81798
    yg #x483ADA7726A3C4655DA4FBFC0E1108A8FD17B448A68554199C47D08FFB10D4B8
    ng #xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141

    ;; this constant is necessary both for computation and validation
    p  #.`(- ,@(mapcar (lambda (n) (ash 1 n)) '(256 32 9 8 7 6 4 0)))
    ))

;;; operations within the field of positive integers modulo the prime p
(macrolet ((define-operations (&rest pairs)
             `(progn ,@(loop for (op name) on pairs by #'cddr collect
                            `(defun ,name (x y) (mod (,op x y) p))))))
  (define-operations + add - sub * mul))

;;; modular exponentiation by squaring, still in the same field
;;; THIS IS A VARIABLE-TIME ALGORITHM, BLIND REUSE IS INSECURE!
(defun pow (x n &optional (x^n 1))      ; (declare (notinline pow))
  (do ((x x (mul x x)) (n n (ash n -1))) ((zerop n) x^n)
    (when (oddp n) (setf x^n (mul x^n x)))))

;;; extended euclidean algorithm, still in the same field
;;; THIS IS A VARIABLE-TIME ALGORITHM, BLIND REUSE IS INSECURE!
(defun eea (a b &optional (x 0) (prevx 1) (y 1) (prevy 0))
  (if (zerop b) (values prevx prevy)
      (multiple-value-bind (q r) (floor a b)
        (eea b r (sub prevx (mul q x)) x (sub prevy (mul q y)) y))))

;;; multiplicative inverse in the field of integers modulo the prime p
(defun inv (x) (nth-value 1 (eea p (mod x p))))

;;; operation, in the group of rational points over elliptic curve "SECP256K1"
;;; THIS IS A VARIABLE-TIME ALGORITHM, BLIND REUSE IS INSECURE!
(defun addp (xp yp xq yq) ; https://hyperelliptic.org/EFD/g1p/auto-shortw.html
  (if (and xp yp xq yq) ; base case: avoid The Pothole At The End Of The Algebra
      (macrolet ((ua (s r) `(let* ((s ,s) (x (sub (mul s s) ,r)))
                              (values x (sub 0 (add yp (mul s (sub x xp))))))))
        (if (/= xp xq) (ua (mul (sub yp yq) (inv (- xp xq))) (add xp xq)) ; p+q
            (if (zerop (add yp yq)) (values nil nil) ; p = -q, so p+q = infinity
                (ua (mul (inv (* 2 yp)) (mul 3 (pow xp 2))) (mul 2 xp))))) ; 2*p
      (if (and xp yp) (values xp yp) (values xq yq)))) ; pick the [in]finite one

;;; Scalar multiplication (by doubling)
;;; THIS IS A VARIABLE-TIME ALGORITHM, BLIND REUSE IS INSECURE!
(defun smulp (k xp yp)
  (if (zerop k) (values nil nil)
      (multiple-value-bind (xq yq) (addp xp yp xp yp)
        (multiple-value-bind (xr yr) (smulp (ash k -1) xq yq)
          (if (evenp k) (values xr yr) (addp xp yp xr yr))))))

;;; Tests if a point is on the curve
;;; THIS IS A VARIABLE-TIME ALGORITHM, BLIND REUSE IS INSECURE!
(defun e (x y) (= (mul y y) (add (pow x #o3) #o7)))

;;; "A horseshoe brings good luck even to those of little faith." - S. Nakamoto
(macrolet ((check-sanity (&rest checks)
             `(progn ,@(loop for (test text) on checks by #'cddr
                          collect `(assert ,test () ,text)))))
  (check-sanity (= 977 (sub (pow 2 256) (pow 2 32))) "mathematics has broken"
                (e xg yg) "the generator isn't a rational point on the curve"
                (not (smulp ng xg yg)) "the generator's order is incorrect"))

;;; dyslexia-friendly encoding, placed in public domain by Satoshi Nakamoto
(defun base58enc (bytes)
  (loop with code = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz"
     for x = (octets-to-integer bytes) then (floor x #10R58) until (zerop x)
     collect (char code (mod x #10R58)) into out finally
       (return (coerce (nreverse (append out (loop for b across bytes
                                                while (zerop b) collect #\1)))
                       'string))))

;;; encodes arbitrary coordinates into a Pay-To-Pubkey-Hash address
(defun pubkey-to-p2pkh (x y)
  ;; ... ok, the previous comment was a lie; the following line verifies that
  ;; the coordinates correspond to a rational point on the curve, and gives a
  ;; few chances to correct typos in either of the coordinates interactively.
  (assert (e x y) (x y) "The point (~D, ~D) is off the curve secp256k1." x y)
  (labels ((digest (hashes bytes)
             (reduce 'digest-sequence hashes :from-end t :initial-value bytes))
           (sovcat (&rest things)
             (apply 'concatenate 'simple-octet-vector things))
           (checksum (octets)
             (sovcat octets (subseq (digest '(sha256 sha256) octets) 0 4))))
    (let ((point (sovcat '(4) (integer-to-octets x) (integer-to-octets y))))
      (base58enc (checksum (sovcat '(0) (digest '(ripemd-160 sha256) point)))))))
