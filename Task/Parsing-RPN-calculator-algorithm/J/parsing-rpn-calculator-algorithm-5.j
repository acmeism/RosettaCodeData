rpnD=: 3 :0
  queue=. |.3 :'|.3 :y 0'::]each;: y
  op=. 1 :'2 (u~/@:{.,}.)S:0 ,@([smoutput)@]'
  ops=. +op`(-op)`(*op)`(%op)`(^op)`(,&;)
  choose=. ((;:'+-*/^')&i.@[)
  ,ops@.choose/queue
)
