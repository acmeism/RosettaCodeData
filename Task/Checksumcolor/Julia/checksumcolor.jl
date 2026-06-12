while(occursin(r"^[\d\w]{32}", (begin s = readline() end)))
    (crc, restofline) = split(s, " ", limit=2)
    for i in 1:3:length(crc)-3
        print("\e[38;2", join([";$(16 * parse(Int, string(c), base=16))"
            for c in crc[i:i+2]], ""), "m", crc[i:i+2])
    end
    println("\e[0m", crc[end-1:end], " ", restofline)
end
