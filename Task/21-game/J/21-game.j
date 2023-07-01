g21=: summarize@play@setup ::('g21: error termination'"_)

NB. non-verb must be defined before use, otherwise are assumed verbs.
Until=: 2 :'u^:(0-:v)^:_'

t=: 'score turn choice'
(t)=: i. # ;: t
empty erase't'

Fetch=: &{
Alter=: }

play=: move Until done
done=: 21 <: score Fetch
move=: [: update you`it@.(turn Fetch)

update=: swap@display@add
add=: score Alter~ (score Fetch + choice Fetch)
display=: [ ([: echo 'sum: {}' format~ score Fetch)
swap=: turn Alter~ ([: -. turn Fetch)

it=: ([ [: echo 'It chose {}.' format~ choice Fetch)@(choice Alter~ cb)
cb=: (1:`r`3:`2:)@.(4 | score Fetch)     NB. computer brain
r=: 3 :'>:?3'

you=: qio1@check@acquire@prompt
prompt=: [ ([: echo 'your choice?'"_)
acquire=: choice Alter~ ('123' i. 0 { ' ' ,~ read)
check=: (choice Alter~ (665 - score Fetch))@([ ([: echo 'g21: early termination'"_))^:(3 = choice Fetch)
qio1=: choice Alter~ ([: >: choice Fetch)

setup=: ([ [: echo 'On your turn enter 1 2 or 3, other entries exit'"_)@((3 :'?2') turn Alter ])@0 0 0"_  NB. choose first player randomly
summarize=: ' won' ,~  (];._2 'it you ') {~ turn Fetch

read=: 1!:1@:1:
write=: 1!:2 4: NB. unused
format=: ''&$: :([: ; (a: , [: ":&.> [) ,. '{}' ([ (E. <@}.;._1 ]) ,) ])
