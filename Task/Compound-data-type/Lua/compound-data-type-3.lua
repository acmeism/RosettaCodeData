local oldtype = type;                   -- store original type function
function type(v)
    local vType = oldtype(v)
    if (vType=="table" and v.type) then
        return v:type()                 -- bypass original type function if possible
    else
        return vType
    end--if vType=="table"
end--type
