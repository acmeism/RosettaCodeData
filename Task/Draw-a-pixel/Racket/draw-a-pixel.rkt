#lang racket
(require racket/draw)
(let ((b (make-object bitmap% 320 240)))
  (send b set-argb-pixels 100 100 1 1 (bytes 255 0 0 255))
  b)
