cyc1=:3 :0
  writes=. 0
  for_index. i.(#y)-1 do.
    item=. index{y
    adj=. item+/ .>(1+index)}.y
    if. 0<adj do.
      pos=. index+adj
      while. item=pos{y do. pos=.pos+1 end.
      writes=. writes+1
      t=. pos{y
      y=. item pos} y
      item=. t
      while. pos ~: index do.
        pos=. index+item+/ .>(1+index)}.y
        while. item=pos{y do. pos=.pos+1 end.
        writes=. writes+1
        t=. pos{y
        y=. item pos} y
        item=. t
      end.
    end.
  end.
  smoutput (":writes),' writes'
  y
)
