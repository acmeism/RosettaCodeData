#lang racket
; This file contains utf-8 charachters: λ, α, γ ...
(for ([c (in-port read-char (open-input-file "read-file.rkt"))])
  (display c))
