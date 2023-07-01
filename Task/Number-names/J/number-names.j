u=. ;:'one two three four five six seven eight nine'
v=. ;:'ten eleven twelve thirteen fourteen fifteen sixteen seventeen eighteen nineteen'
t=. ;:'twenty thirty forty fifty sixty seventy eighty ninety'
EN100=: '' ; u , v , , t ,&.>/ '';'-',&.>u

z=. '' ; 'thousand' ; (;:'m b tr quadr quint sext sept oct non'),&.> <'illion'
u=. ;:'un duo tre quattuor quin sex septen octo novem'
t=. (;:'dec vigint trigint quadragint quinquagint sexagint septuagint octogint nonagint'),&.><'illion'
ENU=: z , (, t ,~&.>/ '';u) , <'centillion'

en3=: 4 : 0
 'p q'=. 0 100#:y
 (p{::EN100),((*p)#' hundred'),((p*&*q)#x),q{::EN100
)

en=: 4 : 0
 d=. 1000&#.^:_1 y
 assert. (0<:y) *. ((=<.)y) *. d <:&# ENU
 c=. x&en3&.> (*d)#d
 ((0=y)#'zero') , (-2+*{:d) }. ; , c,.(<' '),.(ENU{~I.&.|.*d),.<', '
)

uk=: ' and '&en   NB. British
us=: ' '    &en   NB. American
