include get.e

function val(sequence s)
    sequence x
    x = value(s)
    return x[2]
end function

sequence s

s = "12345"
s = sprintf("%d",{val(s)+1})
