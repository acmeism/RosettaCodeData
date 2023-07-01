(defun log (msg)
  (let ((`#(,h ,m ,s) (erlang:time)))
    (lfe_io:format "~2.B:~2.B:~2.B => ~s~n" `(,h ,m ,s ,msg))))

(defun task ()
  (log "Task start")
  (receive
    ('go 'ok))
  (log "Task resumed"))

(defun run ()
  (log "Program start")
  (let ((pid (spawn (lambda () (task)))))
    (progn
      (log "Program sleeping")
      (timer:sleep 1000)
      (log "Program signalling event")
      (! pid 'go)
      (timer:sleep 100))))
