metcon=: {{
  sleep=: 6!:3
  task=: {{
    11 T. lock               NB. wait
    sleep 2
    echo 'Task ',y,&":' has the semaphore'
    13 T. lock               NB. release
  }}
  lock=: 10 T. 0
  0&T.@'' each i.0>.4-1 T.'' NB. ensure at least four threads
  > task t.''"0 i.10         NB. dispatch and wait for 10 tasks
  14 T. lock                 NB. discard lock
}}
