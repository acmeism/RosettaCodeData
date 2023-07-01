MakeList=: dyad define
  sep_MakeList_=: x
  cnt_MakeList_=: 0
  ;MakeItem each y
)

MakeItem=: verb define
  cnt_MakeList_=: cnt_MakeList_+1
  (":cnt_MakeList_),sep_MakeList_,y,LF
)
