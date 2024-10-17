procedure use(integer fi, integer a, integer b)
    print(1,call_func(fi,{a,b}))
end procedure

function add(integer a, integer b)
    return a + b
end function

use(routine_id("add"),23,45)
