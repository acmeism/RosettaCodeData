#lang racket
(parameterize ([current-custodian (make-custodian)])
  (define (loop) (printf "looping\n") (sleep 1) (loop))
  (thread loop) ; start a thread under the new custodian
  (sleep 5)
  ;; kill it: this will kill the thread, and any other opened resources
  ;; like file ports, network connections, etc
  (custodian-shutdown-all (current-custodian)))
