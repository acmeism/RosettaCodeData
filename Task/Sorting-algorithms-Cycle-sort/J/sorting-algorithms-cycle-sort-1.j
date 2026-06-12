noncyc=:3 :0
  writes=. 0
  for_item. /:~y do.
    if. item ~: item_index{y do.
      writes=. writes+1
      y=.item item_index} y
    end.
  end.
  smoutput (":writes),' writes'
  y
)
