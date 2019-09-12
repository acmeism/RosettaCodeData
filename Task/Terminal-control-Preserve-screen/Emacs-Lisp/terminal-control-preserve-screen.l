#!/usr/local/bin/emacs --script
;; -*- lexical-binding: t; -*-

;; "ESC [ ? 1049 h" - Enable alternative screen buffer
(princ "\033[?1049h")
(princ "Alternate screen buffer\n")

(let ((i 5))
  (while (> i 0)
    (princ (format "\rgoing back in %d..." i))
    ;; flush stdout
    (set-binary-mode 'stdout t)
    (sleep-for 1)
    (setq i (1- i))))

;; "ESC [ ? 1049 l" - Disable alternative screen buffer
(princ "\033[?1049l")
