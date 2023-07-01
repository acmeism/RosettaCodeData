allBlocks = ["BO", "XK", "DQ", "CP", "NA", "GT", "RE", "TG", "QD", "FS", "JW", "HU", "VI", "AN", "OB", "ER", "FS", "LY", "PC", "ZM"]

swap = function(list, index1, index2)
    tmp = list[index1]
    list[index1] = list[index2]
    list[index2] = tmp
end function

canMakeWord = function(str, blocks)
    if str == "" then return true
    c = str[0].upper
    for i in range(0, blocks.len - 1)
        bl = blocks[i]
        if c != bl[0] and c != bl[1] then continue
        swap blocks, 0, i
        if canMakeWord(str[1:], blocks[1:]) then return true
        swap blocks, 0, i
    end for
    return false
end function

for val in ["", "A", "BARK", "book", "Treat", "COMMON", "sQuAD", "CONFUSE"]
    out = """"""
    if val.len != 0 then out = val
    print out + ": " + canMakeWord(val, allBlocks)
end for
