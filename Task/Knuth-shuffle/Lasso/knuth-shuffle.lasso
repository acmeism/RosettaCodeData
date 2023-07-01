define staticarray->swap(p1::integer,p2::integer) => {
    fail_if(
        #p1 < 1 or #p2 < 1 or
        #p1 > .size or #p2 > .size,
        'invalid parameters'
    )
    #p1 == #p2
        ? return

    local(tmp) = .get(#p2)
    .get(#p2)  = .get(#p1)
    .get(#p1)  = #tmp
}
define staticarray->knuthShuffle => {
    loop(-from=.size, -to=2, -by=-1) => {
        .swap(math_random(1, loop_count), loop_count)
    }
}

(1 to 10)->asStaticArray->knuthShuffle&asString
