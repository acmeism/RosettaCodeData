julia> """
       # Y combinator

       * `λf. (λx. f (x x)) (λx. f (x x))`
       """
       Y = f -> (x -> x(x))(y -> f((t...) -> y(y)(t...)))
