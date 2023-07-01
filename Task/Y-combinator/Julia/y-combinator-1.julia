               _
   _       _ _(_)_     |  Documentation: https://docs.julialang.org
  (_)     | (_) (_)    |
   _ _   _| |_  __ _   |  Type "?" for help, "]?" for Pkg help.
  | | | | | | |/ _` |  |
  | | |_| | | | (_| |  |  Version 1.6.3 (2021-09-23)
 _/ |\__'_|_|_|\__'_|  |  Official https://julialang.org/ release
|__/                   |

julia> using Markdown

julia> @doc md"""
       # Y Combinator

       $λf. (λx. f (x x)) (λx. f (x x))$
       """ ->
       Y = f -> (x -> x(x))(y -> f((t...) -> y(y)(t...)))
Y
