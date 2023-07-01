(let ((proc (make-network-process :name "my sock"
                                  :host 'local    ;; or hostname string
                                  :service 256)))
  (process-send-string proc "hello socket world")
  (delete-process proc))
