include Settings

say 'SORT COMPOSITE ARRAY - 5 Mar 2025'
say version
say
call Create
call Show 'Not ordered'
call SortStateCity
call Show 'By state and city'
call SortPopCityN
call Show 'By pop (numeric desc) and city'
table = 'states.'; keys = 'pop. state.'; data = 'city.'
call SortPopCityS table,keys,data
call Show 'By pop (string) and city'
table = 'states.'; keys = 'city. state.'; data = 'pop.'
call SortCityState table,keys,data
call Show 'By city and state'
return

Create:
states = 'States.txt'
call Stream states,'c','open read'
states. = ''; n = 0
do while lines(states) > 0
   record = linein(states)
   parse var record rstate','rcity','rpop
   n = n+1; states.state.n = rstate; states.city.n = rcity; states.pop.n = rpop
end
call Stream states,'c','close'
states.0 = n
return

Show:
procedure expose states.
arg header
say center(header,53)
say right('row',3) left('state',20) left('city',20) right('pop',7)
do n = 1 to states.0
   say right(n,3) left(states.state.n,20) left(states.city.n,20) right(states.pop.n,7)
end
say
return

include Quicksort21 [label]=SortStateCity [table]=states. [key1]=state. [key2]=city. [data1]=pop.
include Quicksort21 [label]=SortPopCityN [table]=states. [key1]=pop. [key2]=city. [data1]=state. [lt]=> [gt]=<
include Quicksort [label]=SortCityState
include Quicksort [label]=SortPopCityS [lt]=<< [gt]=>>
