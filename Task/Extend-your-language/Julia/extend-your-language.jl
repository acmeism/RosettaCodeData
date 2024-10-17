const CSTACK1 = Array{Bool,1}()
const CSTACK2 = Array{Bool,1}()
const CSTACK3 = Array{Bool,1}()

macro if2(condition1, condition2, alltrue)
    if !(length(CSTACK1) == length(CSTACK2) == length(CSTACK3))
        throw("prior if2 statement error: must have if2, elseif1, elseif2, and elseifneither")
    end
    ifcond1 = eval(condition1)
    ifcond2 = eval(condition2)
    if ifcond1 && ifcond2
        eval(alltrue)
        push!(CSTACK1, false)
        push!(CSTACK2, false)
        push!(CSTACK3, false)
    elseif ifcond1
        push!(CSTACK1, true)
        push!(CSTACK2, false)
        push!(CSTACK3, false)
    elseif ifcond2
        push!(CSTACK1, false)
        push!(CSTACK2, true)
        push!(CSTACK3, false)
    else
        push!(CSTACK1, false)
        push!(CSTACK2, false)
        push!(CSTACK3, true)
    end
end

macro elseif1(block)
    quote
        if pop!(CSTACK1)
            $block
        end
    end
end

macro elseif2(block)
    quote
        if pop!(CSTACK2)
            $block
        end
    end
end

macro elseifneither(block)
    quote
        if pop!(CSTACK3)
            $block
        end
    end
end


# Testing of code starts here

@if2(2 != 4, 3 != 7, begin x = "all"; println(x) end)

@elseif1(begin println("one") end)

@elseif2(begin println("two") end)

@elseifneither(begin println("neither") end)


@if2(2 != 4, 3 == 7, println("all"))

@elseif1(begin println("one") end)

@elseif2(begin println("two") end)

@elseifneither(begin println("neither") end)


@if2(2 == 4, 3 != 7, begin x = "all"; println(x) end)

@elseif1(begin println("one") end)

@elseif2(begin println("two") end)

@elseifneither(begin println("neither") end)


@if2(2 == 4, 3 == 7, println("last all") end)

@elseif1(begin println("one") end)

@elseif2(begin println("two") end)

@elseifneither(begin println("neither") end)
