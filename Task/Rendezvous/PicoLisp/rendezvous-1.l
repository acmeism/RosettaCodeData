(de rendezvous (Pid . Exe)
   (when
      (catch '(NIL)
         (tell Pid 'setq 'Rendezvous (lit (eval Exe)))
         NIL )
      (tell Pid 'quit @) ) )  # Raise caught error in caller
