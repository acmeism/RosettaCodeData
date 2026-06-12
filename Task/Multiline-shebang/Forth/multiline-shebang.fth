#! /bin/sh
#0 [IF] \ lines below read by shell but ignored by Gforth
   exec gforth \
   -m 256M \
   -d 16M \
   "$0" "$@"
[THEN]
.( hello world) CR BYE
