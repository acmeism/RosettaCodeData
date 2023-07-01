queue_fifo_=: ''

pop_fifo_=: verb define
  r=. {. ::] queue
  queue=: }.queue
  r
)

push_fifo_=: verb define
  queue=: queue,y
  y
)

isEmpty_fifo_=: verb define
  0=#queue
)
