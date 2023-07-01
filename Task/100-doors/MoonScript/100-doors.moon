is_open = [false for door = 1,100]

for pass = 1,100
    for door = pass,100,pass
        is_open[door] = not is_open[door]

for i,v in ipairs is_open
    print "Door #{i}: " .. if v then 'open' else 'closed'
