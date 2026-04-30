integer idM, idF

function F(integer n)
    if n = 0 then
        return 1
    else
        return n - call_func(idM,{F(n-1)})
    end if
end function

idF = routine_id("F")

function M(integer n)
    if n = 0 then
        return 0
    else
        return n - call_func(idF,{M(n-1)})
    end if
end function

idM = routine_id("M")
