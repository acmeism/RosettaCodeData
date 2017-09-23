jq -r -f Natural_sorting.jq Natural_sorting.json

# Ignoring leading spaces
[
  "  ignore leading spaces: 2+0",
  "   ignore leading spaces: 2+1",
  " ignore leading spaces: 2-1",
  "ignore leading spaces: 2-2"
]

# Ignoring multiple adjacent spaces (m.a.s)
[
  "ignore m.a.s   spaces: 2+0",
  "ignore m.a.s    spaces: 2+1",
  "ignore m.a.s  spaces: 2-1",
  "ignore m.a.s spaces: 2-2"
]

# Equivalent whitespace characters
[
  "Equiv.\u000bspaces: 3+0",
  "Equiv.\nspaces: 3+1",
  "Equiv.\tspaces: 3+2",
  "Equiv.\fspaces: 3-1",
  "Equiv.\rspaces: 3-2",
  "Equiv. spaces: 3-3"
]

# Case Indepenent sort
[
  "casE INDEPENENT: 3+0",
  "case INDEPENENT: 3+1",
  "caSE INDEPENENT: 3-1",
  "cASE INDEPENENT: 3-2"
]

# Numeric fields as numerics
[
  "foo100bar10baz0.txt",
  "foo100bar99baz0.txt",
  "foo1000bar99baz9.txt",
  "foo1000bar99baz10.txt"
]

# Title sorts
[
  "The 39 steps",
  "The 40th step more",
  "Wanda",
  "The Wind in the Willows"
]
