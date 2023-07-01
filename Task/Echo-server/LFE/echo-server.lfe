(defun start ()
  (spawn (lambda ()
           (let ((`#(ok ,socket) (gen_tcp:listen 12321 `(#(packet line)))))
             (echo-loop socket)))))

(defun echo-loop (socket)
  (let* ((`#(ok ,conn) (gen_tcp:accept socket))
         (handler (spawn (lambda () (handle conn)))))
    (lfe_io:format "Got connection: ~p~n" (list conn))
    (gen_tcp:controlling_process conn handler)
    (echo-loop socket)))

(defun handle (conn)
  (receive
    (`#(tcp ,conn ,data)
     (gen_tcp:send conn data))
    (`#(tcp_closed ,conn)
     (lfe_io:format "Connection closed: ~p~n" (list conn)))))
