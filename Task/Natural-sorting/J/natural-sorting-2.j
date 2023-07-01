IgnoringLeadingSpaces=:0 :0
ignore leading spaces: 2-2
 ignore leading spaces: 2-1
  ignore leading spaces: 2+0
   ignore leading spaces: 2+1
)

IgnoringMultipleAdjacentSpaces=: 0 :0
 ignore m.a.s spaces: 2-2
 ignore m.a.s  spaces: 2-1
 ignore m.a.s   spaces: 2+0
 ignore m.a.s    spaces: 2+1
)

bsSubst=: rplc&((LF;'\'),('\r';13{a.),('\x0c';12{a.),('\x0b';11{a.),('\n';LF),:'\t';TAB)

EquivalentWhitespaceCharacters=: bsSubst 0 :0
 Equiv. spaces: 3-3
 Equiv.\rspaces: 3-2
 Equiv.\x0cspaces: 3-1
 Equiv.\x0bspaces: 3+0
 Equiv.\nspaces: 3+1
 Equiv.\tspaces: 3+2
)

CaseIndepenent=: 0 :0
 cASE INDEPENENT: 3-2
 caSE INDEPENENT: 3-1
 casE INDEPENENT: 3+0
 case INDEPENENT: 3+1
)

NumericFieldsAsNumerics=: 0 :0
 foo100bar99baz0.txt
 foo100bar10baz0.txt
 foo1000bar99baz10.txt
 foo1000bar99baz9.txt
)

Titles=: 0 :0
 The Wind in the Willows
 The 40th step more
 The 39 steps
 Wanda
)
