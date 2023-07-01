C = setmetatable(require("bc"), {__call=function(t,...) return t.new(...) end})
C.digits(6) -- enough for .nn * .nnnn ==> .nnnnnn, follow with trunc(2) to trim trailing zeroes

subtot = (C"4000000000000000" * C"5.50" + C"2" * C"2.86"):trunc(2) -- cosmetic trunc
tax = (subtot * C"0.0765" + C"0.005"):trunc(2) -- rounding trunc
total = (subtot + tax):trunc(2) -- cosmetic trunc

print(("Before tax:  %20s"):format(subtot:tostring()))
print(("Tax       :  %20s"):format(tax:tostring()))
print(("With tax  :  %20s"):format(total:tostring()))
