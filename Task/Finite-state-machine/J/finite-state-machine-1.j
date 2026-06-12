NB. FSM builder:
explicit=: {{
  states=: ~. states,x;y
  transitions=: ~. transitions,<m
  FSM=: y S (<x S, m T)} (states ,&# transitions){.!._ FSM
  EMPTY
}}
implicit=: ''explicit
start=: {{ '' implicit y [current=: 0 [transitions=: states=: <,FSM=: EMPTY }}

NB. FSM utilities
S=: state=: {{ states i.<m }}
T=: transition=: {{transitions i.<m }}
N=: next=: {{
  try. 1: current=: ([ {&states) current next y catch. 0 end.
:
  (<x, y transition) { FSM
}}
Snm=: statename=: {{ ;:inv m{states }}
Tnm=: transitionname=: {{ ;:inv m{transitions }}
implicits=: {{ r=.'' while. next '' do. r=.r, current end. }}
