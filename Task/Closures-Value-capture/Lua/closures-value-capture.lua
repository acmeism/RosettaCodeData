funcs={}
for i=1,10 do
    table.insert(funcs, function() return i*i end)
end
funcs[2]()
funcs[3]()
