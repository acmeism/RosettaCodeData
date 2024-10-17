function lookandsay(s::String)
    rst = IOBuffer()
    c = 1
    for i in 1:length(s)
        if i != length(s) && s[i] == s[i+1]
            c += 1
        else
            print(rst, c, s[i])
            c = 1
        end
    end
    String(take!(rst))
end


function lookandsayseq(n::Integer)
    rst = Vector{String}(undef, n)
    rst[1] = "1"
    for i in 2:n
        rst[i] = lookandsay(rst[i-1])
    end
    rst
end

println(lookandsayseq(10))
