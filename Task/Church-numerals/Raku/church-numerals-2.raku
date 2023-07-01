my \zero  = -> \f {                 -> \x { x               }}
my \succ  = -> \n {         -> \f { -> \x { f.(n.(f)(x))    }}}
my \add   = -> \n { -> \m { -> \f { -> \x { m.(f)(n.(f)(x)) }}}}
my \mult  = -> \n { -> \m { -> \f { -> \x { m.(n.(f))(x)    }}}}
my \power = -> \b {                 -> \e { e.(b)           }}

my \to_int   = -> \f { f.( -> \i { i + 1 } ).(0) }
my \from_int = -> \i { i == 0 ?? zero !! succ.( &?BLOCK(i - 1) ) }

my \three = succ.(succ.(succ.(zero)));
my \four  = from_int.(4);

say map -> \f { to_int.(f) },
    add.(   three )( four  ),
    mult.(  three )( four  ),
    power.( four  )( three ),
    power.( three )( four  ),
;
