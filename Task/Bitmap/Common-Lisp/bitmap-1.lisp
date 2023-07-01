(defpackage #:rgb-pixel-buffer
  (:use #:common-lisp)
  (:export #:rgb-pixel-component #:rgb-pixel #:rgb-pixel-buffer
           #:+red+ #:+green+ #:+blue+ #:+black+ #:+white+
           #:make-rgb-pixel #:make-rgb-pixel-buffer #:rgb-pixel-buffer-width
           #:rgb-pixel-buffer-height #:rgb-pixel-red #:rgb-pixel-green
           #:rgb-pixel-blue #:fill-rgb-pixel-buffer))
