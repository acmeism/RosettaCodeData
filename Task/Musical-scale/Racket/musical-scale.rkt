#lang racket
(require ffi/unsafe ffi/unsafe/define)
(define-ffi-definer defmm (ffi-lib "Winmm"))
(defmm midiOutOpen (_fun [h : (_ptr o _int32)] [_int = -1] [_pointer = #f]
                         [_pointer = #f] [_int32 = 0] -> _void -> h))
(defmm midiOutShortMsg (_fun _int32 _int32 -> _void))
(define M (midiOutOpen))
(define (midi x y z) (midiOutShortMsg M (+ x (* 256 y) (* 65536 z))))

(for ([i '(60 62 64 65 67 69 71 72)]) (midi #x90 i 127) (sleep 0.5))
(sleep 2)
