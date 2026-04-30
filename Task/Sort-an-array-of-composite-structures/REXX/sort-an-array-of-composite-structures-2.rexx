-- 4 Mar 2026
include Setting

say 'SORT COMPOSITE ARRAY'
say version
say
call ReadSt 'states.state. states.city. states.pop.','States.txt'
call Show 'Not ordered','A'
call SortSt 'states.state. states.city.','states.pop.'
call Show 'By state and city','A'
call SortSt 'states.pop.','states.state. states.city.'
call Show 'By pop (desc)','D'
exit

Show:
procedure expose states.
arg header,seq
say Center(header,53)
say Right('row',3) Left('state',20) Left('city',20) Right('pop',7)
if seq='A' then do
   a=1; i=1; z=states.0
end
else do
   a=states.0; i=-1; z=1
end
do n=a by i to z
   say Right(n,3) Left(states.state.n,20) Left(states.city.n,20) Right(states.pop.n,7)
end
say
return

-- ReadSt; SortSt
include Math
