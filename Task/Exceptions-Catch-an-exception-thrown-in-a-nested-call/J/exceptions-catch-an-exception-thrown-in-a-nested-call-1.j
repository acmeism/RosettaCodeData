main=: monad define
  smoutput 'main'
  try. foo ''
  catcht. smoutput 'main caught ',type_jthrow_
  end.
)

foo=: monad define
  smoutput '  foo'
  for_i. 0 1 do.
    try. bar i
    catcht. if. type_jthrow_-:'U0' do. smoutput '  foo caught ',type_jthrow_ else. throw. end.
    end.
  end.
)

bar=: baz [ smoutput bind '    bar'

baz=: monad define
  smoutput '      baz'
  type_jthrow_=: 'U',":y throw.
)
