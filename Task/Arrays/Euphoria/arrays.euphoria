--Arrays task for Rosetta Code wiki
--User:Lnettnay

atom dummy
--Arrays are sequences
-- single dimensioned array of 10 elements
sequence xarray = repeat(0,10)
xarray[5] = 5
dummy = xarray[5]
? dummy

--2 dimensional array
--5 sequences of 10 elements each
sequence xyarray = repeat(repeat(0,10),5)
xyarray[3][6] = 12
dummy = xyarray[3][6]
? dummy

--dynamic array use (all sequences can be modified at any time)
sequence dynarray = {}
for x = 1 to 10 do
        dynarray = append(dynarray, x * x)
end for
? dynarray

for x = 1 to 10 do
        dynarray = prepend(dynarray, x)
end for
? dynarray
