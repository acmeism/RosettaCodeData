|=  [m=@ud n=@ud]
?:  =(m 0)
  +(n)
?:  =(n 0)
  $(n 1, m (dec m))
$(m (dec m), n $(n (dec n)))
