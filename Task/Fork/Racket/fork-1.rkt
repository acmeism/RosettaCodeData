#lang racket
(define-values [P _out _in _err]
  (subprocess (current-output-port) (current-input-port) (current-error-port)
              (find-executable-path "du") "-hs" "/usr/share"))
;; wait for process to end, print messages as long as it runs
(let loop () (unless (sync/timeout 10 P) (printf "Still running...\n") (loop)))
