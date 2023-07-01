#!/usr/bin/picolisp /usr/lib/picolisp/lib.l

(call 'tput "smcup")
(prinl "something")
(wait 3000)
(call 'tput "rmcup")

(bye)
