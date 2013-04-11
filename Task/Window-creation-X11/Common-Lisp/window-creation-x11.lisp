;;; Single-file/interactive setup; large applications should define an ASDF system instead
(cl:require :asdf)
(asdf:operate 'asdf:load-op :clx)
(cl:defpackage #:rc-xlib-window
  (:use #:cl #:xlib))
(cl:in-package #:rc-xlib-window)

(let ((display (open-default-display)))
  (unwind-protect
      (let* ((window (create-window :parent (screen-root (display-default-screen display))
                                    :x 10
                                    :y 10
                                    :width 100
                                    :height 100
                                    :event-mask '(:exposure :key-press)))
             (gc (create-gcontext :drawable window)))
        (map-window window)
        (event-case (display :discard-p t)
          (exposure ()
            (draw-rectangle window gc 20 20 10 10 t)
            (draw-glyphs window gc 10 40 "Hello, World!")
            nil #| continue receiving events |#)
          (key-press ()
            t #| non-nil result signals event-case to exit |#))))
    (close-display display))
