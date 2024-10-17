g21=: summarize@play@setup ::'g21: error termination'

Until=: {{u^:(0-:v)^:_}}

'score turn choice'=: 0 1 2

play=: move Until done
move=: [: update you`it@.(turn&{)
done=: 21 <: score&{


update=: swap@display@add
add=: score}~ score&{ + choice&{
display=: [ 'sum: {}' echo@format~ score&{
swap=: turn}~ [: -. turn&{

it=: ([ 'It chose {}.' echo@format~ choice&{)@(choice}~ cb)
cb=: 1:`(>:@?@3)`3:`2:@.(4 | score&{)     NB. computer brain

you=: qio1@check@acquire@prompt
prompt=: [ echo@'your choice?'
acquire=: choice}~'123'i.0{' ',~read
check=: (choice}~ 665 - score&{)@([ echo@'g21: early termination')^:(3 = choice&{)
qio1=: choice}~ ([: >: choice&{)

setup=: ([ echo@'On your turn enter 1 2 or 3, other entries exit')@(?@2 turn} ])@0 0 0  NB. choose first player randomly

summarize=: ' won',~ ];._2@'it you '{~turn&{

read=: 1!:1@1
write=: 1!:2&4 NB. unused
format=: ''&$: : ([: ; (a: , [: ":&.> [) ,. '{}' ([ (E. <@}.;._1 ]) ,) ])
