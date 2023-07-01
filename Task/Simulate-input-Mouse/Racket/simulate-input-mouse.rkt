#lang at-exp racket

(require ffi/unsafe)

(define mouse-event
  (get-ffi-obj "mouse_event" (ffi-lib "user32")
               (_fun _int32 _int32 _int32 _int32 _pointer -> _void)))

(mouse-event #x2 0 0 0 #f)
(mouse-event #x4 0 0 0 #f)
