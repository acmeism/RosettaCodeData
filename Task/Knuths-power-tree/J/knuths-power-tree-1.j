knuth_power_tree=:3 :0
  L=: P=: %(1+y){._ 1
  findpath=: ]
  while. _ e.P do.
    for_n.(/: findpath&>)I.L=>./L-._ do.
      for_a. findpath n do.
         j=. n+a
         l=. 1+n{L
         if. j>y do. break. end.
         if. l>:j{ L do. continue. end.
         L=: l j} L
         P=: n j} P
      end.
      findpath=: [: |. {&P^:a:
    end.
  end.
  P
)

usepath=:4 :0
  path=. findpath y
  exp=. 1,({:path)#x
  for_ex.(,.~2 -~/\"1])2 ,\path  do.
    'ea eb ec'=. ex
    exp=.((ea{exp)*eb{exp) ec} exp
  end.
  {:exp
)
