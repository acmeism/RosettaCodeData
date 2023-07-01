function makelist(sep::String)
    cnt = 1

    function makeitem(item::String)
        rst = string(cnt, sep, item, '\n')
        cnt += 1
        return rst
    end

    return makeitem("first") * makeitem("second") * makeitem("third")
end

print(makelist(". "))
