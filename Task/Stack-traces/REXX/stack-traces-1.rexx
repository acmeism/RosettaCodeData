/* call stack */
say 'Call A'
call A '123'
say result
exit 0

A:
say 'Call B'
call B '456'
say result
return ARG(1)

B:
say 'Call C'
call C '789'
say result
return ARG(1)

C:
call callstack
return ARG(1)

callstack: procedure
getcallstack(cs.)
say 'Dump call stack with' cs.0 'items'
do i = 1 to cs.0
    parse var cs.i line func
    say format(line, 3) ':' left(func, 9) ': source "' || sourceline(line) || '"'
end
return cs.0
