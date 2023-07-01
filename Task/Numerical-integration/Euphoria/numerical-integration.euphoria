function int_leftrect(sequence bounds, integer n, integer func_id)
    atom h, sum
    h = (bounds[2]-bounds[1])/n
    sum = 0
    for x = bounds[1] to bounds[2]-h by h do
        sum += call_func(func_id, {x})
    end for
    return h*sum
end function

function int_rightrect(sequence bounds, integer n, integer func_id)
    atom h, sum
    h = (bounds[2]-bounds[1])/n
    sum = 0
    for x = bounds[1] to bounds[2]-h by h do
        sum += call_func(func_id, {x+h})
    end for
    return h*sum
end function

function int_midrect(sequence bounds, integer n, integer func_id)
    atom h, sum
    h = (bounds[2]-bounds[1])/n
    sum = 0
    for x = bounds[1] to bounds[2]-h by h do
        sum += call_func(func_id, {x+h/2})
    end for
    return h*sum
end function

function int_trapezium(sequence bounds, integer n, integer func_id)
    atom h, sum
    h = (bounds[2]-bounds[1])/n
    sum = call_func(func_id, {bounds[1]}) + call_func(func_id, {bounds[2]})
    for x = bounds[1] to bounds[2]-h by h do
        sum += 2*call_func(func_id, {x})
    end for
    return h * sum / 2
end function

function int_simpson(sequence bounds, integer n, integer func_id)
    atom h, sum1, sum2
    h = (bounds[2]-bounds[1])/n
    sum1 = call_func(func_id, {bounds[1] + h/2})
    sum2 = 0
    for i = 1 to n-1 do
        sum1 += call_func(func_id, {bounds[1] + h * i + h / 2})
        sum2 += call_func(func_id, {bounds[1] + h * i})
    end for
    return h/6 * (call_func(func_id, {bounds[1]}) +
                  call_func(func_id, {bounds[2]}) + 4*sum1 + 2*sum2)
end function

function xp2d2(atom x)
    return x*x/2
end function

function logx(atom x)
    return log(x)
end function

function x(atom x)
    return x
end function

? int_leftrect({-1,1},1000,routine_id("xp2d2"))
? int_rightrect({-1,1},1000,routine_id("xp2d2"))
? int_midrect({-1,1},1000,routine_id("xp2d2"))
? int_simpson({-1,1},1000,routine_id("xp2d2"))
puts(1,'\n')
? int_leftrect({1,2},1000,routine_id("logx"))
? int_rightrect({1,2},1000,routine_id("logx"))
? int_midrect({1,2},1000,routine_id("logx"))
? int_simpson({1,2},1000,routine_id("logx"))
puts(1,'\n')
? int_leftrect({0,10},1000,routine_id("x"))
? int_rightrect({0,10},1000,routine_id("x"))
? int_midrect({0,10},1000,routine_id("x"))
? int_simpson({0,10},1000,routine_id("x"))
