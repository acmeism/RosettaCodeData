> julia
               _
   _       _ _(_)_     |  Documentation: https://docs.julialang.org
  (_)     | (_) (_)    |
   _ _   _| |_  __ _   |  Type "?" for help, "]?" for Pkg help.
  | | | | | | |/ _` |  |
  | | |_| | | | (_| |  |  Version 1.1.1 (2019-05-16)
 _/ |\__'_|_|_|\__'_|  |  Official https://julialang.org/ release
|__/                   |

help?>
search: ⊻ ⊋ ⊊ ⊉ ⊈ ⊇ ⊆ ≥ ≤ ≢ ≡ ≠ ≉ ≈ ∪ ∩ ∛ √ ∘ ∌ ∋ ∉ ∈ ℯ π ÷ ~ | ^ \ > < : / - + * & % ! if do IO |> rm pi mv in im fd cp

  Welcome to Julia 1.1.1. The full manual is available at

  https://docs.julialang.org/

  as well as many great tutorials and learning resources:

  https://julialang.org/learning/

  For help on a specific function or macro, type ? followed by its name, e.g. ?cos, or ?@time, and press enter. Type ;
  to enter shell mode, ] to enter package mode.

help?> function
search: function Function functionloc @functionloc @cfunction

  function

  Functions are defined with the function keyword:

  function add(a, b)
      return a + b
  end

  Or the short form notation:

  add(a, b) = a + b

  The use of the return keyword is exactly the same as in other languages, but is often optional. A function without
  an explicit return statement will return the last expression in the function body.
