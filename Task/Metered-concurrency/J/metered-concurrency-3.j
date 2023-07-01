scheduledumb=: {{
  id=:'dumb',":x:6!:9''
  wd 'pc ',id
  (t)=: u {{u 0{::n[y[erase 1{::n}} (y;t=. id,'_timer')
  wd 'ptimer ',":?100
}}

sleep=: 6!:3     NB. seconds
timestamp=: 6!:1 NB. seconds

acquire=: {{
  imprison y
  while. 1<count y do.
    release y
    sleep 0.1
    imprison y
  end.
}}

release=:  {{ counter=: (<:y{counter) y} counter }}
imprison=: {{ counter=: (>:y{counter) y} counter }}
count=:    {{ y { counter }}

counter=: 0 0

demo=: {{
  acquire 0
  echo 'unit ',y,&":' acquired semaphore, t=',":timestamp''
  sleep 2
  release 0
}}
