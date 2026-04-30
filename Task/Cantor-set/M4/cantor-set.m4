local WIDTH = 81
divert(-1)
changequote(`[',`]')

define([Cantor],[dnl
define([cantor],[C()
])dnl
define([line],[C()])dnl
define([C],[[C()C()C()]])dnl
define([_],[[_()_()_()]])dnl
Cantor_loop([$1])dnl
undefine([line])dnl
define([C],[*])dnl
define([_],[ ])dnl
cantor()dnl
undefine([C])dnl
undefine([_])dnl
undefine([cantor])dnl
])

define([Cantor_loop],[ifelse([$1],[0],,[dnl
pushdef([C],[[C()_()C()]])dnl
define([line],line)dnl
popdef([C])dnl
define([cantor],cantor()defn([line])
)dnl
Cantor_loop(decr([$1]))])])

divert(0)Cantor([4])
