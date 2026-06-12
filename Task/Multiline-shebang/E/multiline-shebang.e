#!/bin/sh
>/dev/null; exec rune $0 $0 ${1+"$@"}

println(`I was called as ${interp.getArgs()[0]}.`)
