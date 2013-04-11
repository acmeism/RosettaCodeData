multisplit=:4 :0
  'sep begin'=.|:t=. y /:~&.:(|."1)@;@(i.@#@[ ,.L:0"0 I.@E.L:0) x
  end=. begin + sep { #@>y
  last=.next=.0
  r=.2 0$0
  while.next<#begin do.
    r=.r,.(last}.x{.~next{begin);next{t
    last=.next{end
    next=.1 i.~(begin>next{begin)*.begin>:last
  end.
  r=.r,.'';~last}.x
)
