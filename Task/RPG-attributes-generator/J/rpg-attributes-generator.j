roll=: 1 + 4 6 ?@:$ 6:
massage=: +/ - <./
generate_attributes=: massage@:roll
accept=: (75 <: +/) *. (2 <: [: +/ 15&<:)
Until=: conjunction def 'u^:(0-:v)^:_'

NB. show displays discarded attribute sets
NB. and since roll ignores arguments, echo would suffice in place of show
show=: [ echo

NB. use: generate_character 'name'
generate_character=: (; (+/ ; ])@:([: generate_attributes@:show Until accept 0:))&>@:boxopen
