;;; Single-file/interactive setup; large applications should define an ASDF system instead

(let* ((display (open-default-display))
       (screen (display-default-screen display))
       (root-window (screen-root screen))
       (black-pixel (screen-black-pixel screen))
       (white-pixel (screen-white-pixel screen))
       (window (create-window :parent root-window
                              :x 10 :y 10
                              :width 100 :height 100
                              :background white-pixel
                              :event-mask '(:exposure :key-press)))
       (gc (create-gcontext :drawable window
                            :foreground black-pixel
                            :background white-pixel)))
  (map-window window)
  (unwind-protect
       (event-case (display :discard-p t)
         (exposure ()
                   (draw-rectangle window gc 20 20 10 10 t)
                   (draw-glyphs window gc 10 50 "Hello, World!")
                   nil #| continue receiving events |#)
         (key-press ()
                    t #| non-nil result signals event-case to exit |#))
    (when window
      (destroy-window window))
    (when gc
      (free-gcontext gc))
    (close-display display)))
