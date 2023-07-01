: quibbing(l) -- string
| i s |
   StringBuffer new "{" <<
   l size dup 1- ->s loop: i [
      l at(i) <<
      i s < ifTrue: [ ", " << continue ]
      i s == ifTrue: [ " and " << ]
      ]
   "}" << dup freeze ;
