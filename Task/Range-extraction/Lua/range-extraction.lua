function extractRange (rList)
    local rExpr, startVal = ""
    for k, v in pairs(rList) do
        if rList[k + 1] == v + 1 then
            if not startVal then startVal = v end
        else
            if startVal then
                if v == startVal + 1 then
                    rExpr = rExpr .. startVal .. "," .. v .. ","
                else
                    rExpr = rExpr .. startVal .. "-" .. v .. ","
                end
                startVal = nil
            else
                rExpr = rExpr .. v .. ","
            end
        end
    end
    return rExpr:sub(1, -2)
end

local intList = {
    0,  1,  2,  4,  6,  7,  8, 11, 12, 14,
   15, 16, 17, 18, 19, 20, 21, 22, 23, 24,
   25, 27, 28, 29, 30, 31, 32, 33, 35, 36,
   37, 38, 39
}
print(extractRange(intList))
