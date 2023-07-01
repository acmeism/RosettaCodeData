#macro assign(sym, expr)
    __fb_unquote__(__fb_eval__("#undef " + sym))
    __fb_unquote__(__fb_eval__("#define " + sym + " " + __fb_quote__(__fb_eval__(expr))))
#endmacro

#define a, b, x

assign("a", 8)
assign("b", 7)
assign("x", Sqr(a) + (Sin(b*3)/2))
Print x

assign("x", "goodbye")
Print x

Sleep
