#!/usr/bin/picolisp /usr/lib/picolisp/lib.l

(load "@lib/misc.l")
(if (argv)
   (out "+notes.txt" (prinl (stamp) "^J^I" (glue " " @)))
   (and (info "notes.txt") (in "notes.txt" (echo))) )
(bye)
