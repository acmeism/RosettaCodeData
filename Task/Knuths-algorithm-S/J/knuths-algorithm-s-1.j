s_of_n_creator=: 1 :0
  ctx=: conew&'inefficient' m
  s_of_n__ctx
)

coclass'inefficient'
  create=:3 :0
    N=: y
    ITEMS=: ''
    K=:0
  )

  s_of_n=:3 :0
    K=: K+1
    if. N>:#ITEMS do.
      ITEMS=: ITEMS,y
    else.
      if. (N%K)>?0 do.
        ITEMS=: ((<<<?N){ITEMS),y
      else.
        ITEMS
      end.
    end.
  )
