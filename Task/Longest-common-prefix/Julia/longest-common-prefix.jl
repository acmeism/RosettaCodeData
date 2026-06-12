function lcp(str::AbstractString...)
    r = IOBuffer()
    str = [str...]
    if !isempty(str)
        i = 1
        while all(i ≤ length(s) for s in str) && all(s == str[1][i] for s in getindex.(str, i))
            print(r, str[1][i])
            i += 1
        end
    end
    return String(r)
end

@show lcp("interspecies", "interstellar", "interstate")
@show lcp("throne","throne")
@show lcp("throne","dungeon")
@show lcp("throne", "", "throne")
@show lcp("cheese")
@show lcp("")
@show lcp()
@show lcp("prefix","suffix")
@show lcp("foo","foobar")
