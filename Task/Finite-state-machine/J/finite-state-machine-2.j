NB. task example FSM:
start 'ready'
'ready'   'deposit'explicit 'waiting'
'ready'      'quit'explicit 'exit'
'waiting'  'select'explicit 'dispense'
'waiting'  'refund'explicit 'refunding'
'dispense' 'remove'explicit 'ready'
'refunding'        implicit 'ready'

example=: {{
  current=: 0
  machine 'deposit'
  machine 'select'
  machine 'remove'
  machine 'deposit'
  machine 'refund'
  machine 'quit'
  echo 'final state: ',current statename
}}

machine=: {{
  echo 'state: ',current statename
  echo 'transition: ',y
  next y
  i=. implicits ''
  if. #i do.
    echo 'implicit transition to: ',i statename
  end.
}}
