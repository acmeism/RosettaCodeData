zform=: {{ 10 |."1@(#.inv) y }} :. (10#.|."1) NB. use decimal numbers for representation
zinc=: {{  carry ({.,2}.])carry 1,y }}
zdec=: {{ (|.k$0 1),y }.~k=. 1+y i.1 }}
zadd=: {{ x while. 1 e. y do. x=. zinc x [ y=. zdec y end. }}
zsub=: {{ x while. 1 e. y do. x=. zdec x [ y=. zdec y end. }} NB. intended for unsigned arithmetic
zmul=: {{ t=. 0 0 while. 1 e. y do. t=. t zadd x [ y=. zdec y end. }}
zdiv=: {{ t=. 0 0 while. x zge y do. t=. zinc t [ x=. x zsub y end. }} NB. discards remainder
carry=: {{
  s=. 0
  for_b. y do.
    if. (1+b) = s=. s-_1^b do. y=. (-.b) (b_index-0,b)} y end.
  end.
  if. 2=s do. y,1 else. y end.
}}
zge=: {{ cmp=. x -/@,: y while. (#cmp)*0={:cmp do. cmp=. }:cmp end. 0<:{:cmp }}
