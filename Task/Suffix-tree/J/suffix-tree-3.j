fmttree=: ;@(1&{) showtree~ {: (,~ }.`('[','] ',~":)@.(_>|))each {.

   fmttree suffix_tree 'banana$'
    ┌─ [1] banana$
    │                       ┌─ [2] na$
    │             ┌─ na ────┴─ [4] $
────┼─ a ─────────┴─ [6] $
    │             ┌─ [3] na$
    ├─ na ────────┴─ [5] $
    └─ [7] $
