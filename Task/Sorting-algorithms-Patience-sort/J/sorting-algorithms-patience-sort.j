Until =: 2 :'u^:(0=v)^:_'
Filter =: (#~`)(`:6)

locate_for_append =: 1 i.~ (<&> {:S:0)  NB. returns an index
append =: (<@:(({::~ >:) , 0 {:: [)`]`(}.@:[)}) :: [
pile =: (,  append locate_for_append)/@:(;/)  NB. pile DATA

smallest =: ((>:@:i. , ]) <./)@:({:S:0@:}.) NB. index of pile with smallest value , that value
transfer =: (}:&.>@:({~ {.) , <@:((0{::[),{:@:]))`(1 0 * ])`[}
unpile =: >@:{.@:((0<#S:0)Filter@:(transfer smallest)Until(1=#))@:(a:&,)

patience_sort =: unpile@:pile

assert (/:~ -: patience_sort) ?@$~30    NB. test with 30 randomly chosen integers

Show =: 1 : 0
 smoutput y
 u y
:
 smoutput A=:x ,&:< y
 x u y
)

pile_demo =: (,  append Show  locate_for_append)/@:(;/)  NB. pile DATA
unpile_demo =: >@:{.@:((0<#S:0)Filter@:(transfer Show  smallest)Until(1=#))@:(a:&,)
patience_sort_demo =: unpile_demo@:pile_demo
