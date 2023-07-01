same2=: {{
  i=. 0
  r=. ,EMPTY
  while. i < #y do.
    curr=. i{y
    if. i>0 do.
      if. curr=prev do.
        r=. r,i
      end.
    end.
    prev=. curr
    i=. i+1
  end.
  r
}}
