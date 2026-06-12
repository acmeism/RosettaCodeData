function test()
    @info "starting test()"
    a = [1, 2]
    for i in 1:4
        if i > 3
            @debug "debugging $a at line $(@__LINE__) of file $(@__FILE__)"
        else
            a .*= 2
        end
    end
    @warn "exiting test()"
    println()
end

test()

ENV["JULIA_DEBUG"] = "all"

test()
