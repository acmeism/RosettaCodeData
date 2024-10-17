struct U0 <: Exception end
struct U1 <: Exception end

function foo()
    for i in 1:2
        try
            bar()
        catch err
            if isa(err, U0) println("catched U0")
            else rethrow(err) end
        end
    end
end

function bar()
    baz()
end

function baz()
    if isdefined(:_called) && _called
        throw(U1())
    else
        global _called = true
        throw(U0())
    end
end

foo()
