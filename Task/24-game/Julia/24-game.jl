validexpr(ex::Expr) = ex.head == :call && ex.args[1] in [:*,:/,:+,:-] && all(validexpr, ex.args[2:end])
validexpr(ex::Int) = true
validexpr(ex::Any) = false
findnumbers(ex::Number) = Int[ex]
findnumbers(ex::Expr) = vcat(map(findnumbers, ex.args)...)
findnumbers(ex::Any) = Int[]
function twentyfour()
    digits = sort!(rand(1:9, 4))
    while true
        print("enter expression using $digits => ")
        ex = parse(readline())
        try
            validexpr(ex) || error("only *, /, +, - of integers is allowed")
            nums = sort!(findnumbers(ex))
            nums == digits || error("expression $ex used numbers $nums != $digits")
            val = eval(ex)
            val == 24 || error("expression $ex evaluated to $val, not 24")
            println("you won!")
            return
        catch e
            if isa(e, ErrorException)
                println("incorrect: ", e.msg)
            else
                rethrow()
            end
        end
    end
end
