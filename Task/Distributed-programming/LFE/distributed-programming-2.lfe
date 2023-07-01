> (defun get-server-name ()
    (list_to_atom (++ "exampleserver@" (element 2 (inet:gethostname)))))

> (defun start ()
    (net_kernel:start `(,(get-server-name) shortnames))
    (erlang:set_cookie (node) 'rosettaexample)
    (let ((pid (spawn #'listen/0)))
      (register 'serverref pid)
      (io:format "~p ready~n" (list (node pid)))
      'ok))

> (defun listen ()
    (receive
      (`#(echo ,pid ,data)
        (io:format "Got ~p from ~p~n" (list data (node pid)))
        (! pid `#(hello ,data))
        (listen))
      (x
        (io:format "Unexpected pattern: ~p~n" `(,x)))))
