#!/usr/bin/picolisp /usr/lib/picolisp/lib.l

(de chat Lst
   (out *Sock
      (mapc prin Lst)
      (prinl) ) )

(setq *Port (port 4004))

(loop
   (setq *Sock (listen *Port))
   (NIL (fork) (close *Port))
   (close *Sock) )

(out *Sock
   (prin "Please enter your name: ")
   (flush) )
(in *Sock (setq *Name (line T)))

(tell 'chat "+++ " *Name " arrived +++")

(task *Sock
   (in @
      (ifn (eof)
         (tell 'chat *Name "> " (line T))
         (tell 'chat "--- " *Name " left ---")
         (bye) ) ) )
(wait)
