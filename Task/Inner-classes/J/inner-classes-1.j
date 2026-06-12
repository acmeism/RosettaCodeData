coclass 'baggagecheck'

create=: {{
  data=: keys=: i.0
  mysn=: '' conew 'serialnumber'
}}

create_serialnumber_=: {{number=: 0}}
destroy_serialnunber_=: codestroy
get_serialnumber_=: {{number=: 1+number}}

destroy=: {{
  destroy__mysn ''
  codestroy ''
}}

checkin=: {{
  sn=.get__mysn''
  data=: data,<y
  keys=: keys,sn
  sn
}}

checkout=: {{
  r=.>(keys i. y){data
  b=. keys~:y
  data=: b#data
  keys=: b#keys
  r
}}
