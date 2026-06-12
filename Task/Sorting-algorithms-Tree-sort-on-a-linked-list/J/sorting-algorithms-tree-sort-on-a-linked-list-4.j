left=: i.0
right=: i.0
data=: i.0

insert=:3 :0"0
  k=. 0
  assert. (left =&# right) * (left =&# data)
  if. 0<#data do.
    while. k<#data do.
      if. y=k{data do.return.end.
      n=. k
      if. y<k{data do.
        k=. k{".p=.'left'
      else.
        k=. k{".p=.'right'
      end.
    end.
    (p)=:(#data) n} ".p
  end.
  left=:left, _
  right=:right, _
  data=:data,y
  i.0 0
)

flatten=:3 :0
  extract 0
)

extract=:3 :0
  if. y>:#data do.'' return. end.
  (extract y{left),(y{data),extract y{right
)
