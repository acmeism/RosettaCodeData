U0 := Exception clone
U1 := Exception clone

foo := method(
    for(i,1,2,
        try(
            bar(i)
        )catch( U0,
            "foo caught U0" print
        )pass
    )
)
bar := method(n,
    baz(n)
)
baz := method(n,
    if(n == 1,U0,U1) raise("baz with n = #{n}" interpolate)
)

foo
