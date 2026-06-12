alpha(s, v) = map(i -> s[i], v)

function distinctPerms(spec)
    function perm(elements)
        if length(elements) == 1
            deepcopy(elements)
        else
          [pushfirst!(p, elements[k][1]) for k in 1:length(elements) for p in perm(filter(dups -> length(dups) != 0,
            [ if i == k dups[2:end] else dups end
              for (i, dups) in enumerate(elements)]))
          ]
        end
    end
    elements = [fill(x...) for x in enumerate(spec)]
    perm(elements)
end

println(map(p -> join(alpha("ABC", p), ""), distinctPerms([2, 3, 1])))
