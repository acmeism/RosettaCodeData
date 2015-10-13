" Translated from Python.  Works with: Vim 7.0

func! Lambx(sig, expr, dict)
    let fanon = {'d': a:dict}
    exec printf("
	\func fanon.f(%s) dict\n
	\  return %s\n
	\endfunc",
	\ a:sig, a:expr)
    return fanon
endfunc

func! Callx(fanon, arglist)
    return call(a:fanon.f, a:arglist, a:fanon.d)
endfunc

let g:Y = Lambx('f', 'Callx(Lambx("x", "Callx(a:x, [a:x])", {}), [Lambx("y", ''Callx(self.f, [Lambx("...", "Callx(Callx(self.y, [self.y]), a:000)", {"y": a:y})])'', {"f": a:f})])', {})

let g:fac = Lambx('f', 'Lambx("n", "a:n<2 ? 1 : a:n * Callx(self.f, [a:n-1])", {"f": a:f})', {})

echo Callx(Callx(g:Y, [g:fac]), [5])
echo map(range(10), 'Callx(Callx(Y, [fac]), [v:val])')
