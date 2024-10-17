function calcpass(passwd, nonce::String)
    startflag = true
    n1 = 0
    n2 = 0
    password = parse(Int, passwd)
    dact = Dict(
                '1' => () -> begin n1 = (n2 & 0xffffff80) >> 7; n2 <<= 25 end,
                '2' => () -> begin n1 = (n2 & 0xfffffff0) >> 4; n2 <<= 28 end,
                '3' => () -> begin n1 = (n2 & 0xfffffff8) >> 3; n2 <<= 29 end,
                '4' => () -> begin n1 = n2 << 1; n2 >>= 31 end,
                '5' => () -> begin n1 = n2 << 5; n2 >>= 27 end,
                '6' => () -> begin n1 = n2 << 12; n2 >>= 20 end,
                '7' => () -> begin n1 = (n2 & 0x0000ff00) | ((n2 & 0x000000ff) << 24) |
                             ((n2 & 0x00ff0000) >> 16); n2 = (n2 & 0xff000000) >> 8 end,
                '8' => () -> begin n1 = ((n2 & 0x0000ffff) << 16) | (n2 >> 24);
                             n2 = (n2 & 0x00ff0000) >> 8 end,
                '9' => () -> begin n1 = ~n2 end)

    for c in nonce
        if !haskey(dact, c)
            n1 = n2
        else
            if startflag
                n2 = password
            end
            startflag = false
            dact[c]()
            n1 &= 0xffffffff
            n2 &= 0xffffffff
            if c != '9'
                n1 |= n2
            end
        end
        n2 = n1
    end
    n1
end

function testcalcpass()
    tdata = [["12345", "603356072", "25280520"], ["12345", "410501656", "119537670"],
             ["12345", "630292165", "4269684735"], ["12345", "523781130", "537331200"]]
	for td in tdata
        pf = calcpass(td[1], td[2]) == parse(Int, td[3]) ? "Passes test." : "Fails test."
        println("Calculating pass for [$(td[1]), $(td[2])] = $(td[3]): $pf")
    end
end

testcalcpass()
