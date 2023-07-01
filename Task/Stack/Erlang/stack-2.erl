1> c(stack).
{ok,stack}
2> Stack = stack:new().
[]
3> NewStack = lists:foldl(fun stack:push/2, Stack, [1,2,3,4,5]).
[5,4,3,2,1]
4> stack:top(NewStack).
5
5> {Popped, PoppedStack} = stack:pop(NewStack).
{5,[4,3,2,1]}
6> stack:empty(NewStack).
false
7> stack:empty(stack:new()).
true
