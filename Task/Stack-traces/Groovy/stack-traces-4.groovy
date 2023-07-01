#<p>
#  Compute the current stack trace.  Starting at level <i>n</i> above
#  the current procedure.  Here, <i>n</i> defaults to 0, which will
#  include this procedure in the stack trace.
#  <i>ce</i> defaults to &current.
#  <i>This only works with newer versions of Unicon!</i>
#  <[generates the stacktrace from current call back to first
#   in the co-expression]>
#</p>
procedure buildStackTrace(n:0,  # starting distance from this call
                          ce    # co-expr to trace stack in [&current]
                         )
    local L
    /ce := &current
    L := []; n -:= 1
    while pName := image(proc(ce, n+:=1)) do {
        fName := keyword("&file",ce,n) | "no file name"
        fLine := keyword("&line",ce,n) | "no line number"
        put(L, pName||" ["||fName||":"||fLine||"]" )
        }
    return L
end
