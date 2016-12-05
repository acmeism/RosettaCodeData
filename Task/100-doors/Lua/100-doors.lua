local is_open = {}

for pass = 1,100 do
    for door = pass,100,pass do
        is_open[door] = not is_open[door]
    end
end

for i,v in next,is_open do
    print ('Door '..i..':',v and 'open' or 'close')
end
