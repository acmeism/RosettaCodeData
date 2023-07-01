stack:()
push:{stack::x,stack}
pop:{r:*stack;stack::1_ stack;r}
empty:{0=#stack}

/example:
stack:()
  push 3
  stack
,3
  push 5
  stack
5 3
  pop[]
5
  stack
,3
  empty[]
0
  pop[]
3
  stack
!0
  empty[]
1
