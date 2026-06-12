for i in 0 .. 1000
    bin = i.to_s(2)
    if bin.length % 2 == 0 then
        half = bin.length / 2
        if bin[0..half-1] == bin[half..] then
            print "%3d: %10s\n" % [i, bin]
        end
    end
end
