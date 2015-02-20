iter = io.lines 'test.txt'
for i=0, 5 do
    if not iter() then
        error 'Not 7 lines in file'
    end
end

line = iter()
