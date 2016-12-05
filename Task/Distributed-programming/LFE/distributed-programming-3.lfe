> (defun get-server-name ()
    (list_to_atom (++ "exampleserver@" (element 2 (inet:gethostname)))))

> (defun send (data)
    (net_kernel:start '(exampleclient shortnames))
    (erlang:set_cookie (node) 'rosettaexample)
    (io:format "connecting to ~p~n" `(,(get-server-name)))
    (! `#(serverref ,(get-server-name)) `#(echo ,(self) ,data))
    (receive
      (`#(hello ,data)
        (io:format "Received ~p~n" `(,data)))
      (x
        (io:format "Unexpected pattern: ~p~n" (list x))))
    'ok)
