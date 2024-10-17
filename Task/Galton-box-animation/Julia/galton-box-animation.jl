using Random
function drawball(timer)
    global r, c, d
    print("\e[$r;$(c)H ")       # clear last ball position (r,c)
    if (r+=1) > 14
        close(timer)
        b = (bin[(c+2)>>2] += 1)# update count in bin
        print("\e[$b;$(c)Ho")   # lengthen bar of balls in bin
    else
        r in 3:2:13 && c in 17-r:4:11+r && (d = 2bitrand()-1)
        print("\e[$r;$(c+=d)Ho")# show ball moving in direction d
    end
end

print("\e[2J")                  # clear screen
for r = 3:2:13, c = 17-r:4:11+r # 6 pins in 6 rows
    print("\e[$r;$(c)H^")       # draw pins
end
print("\e[15;2H-------------------------")

bin = fill(15,7)                # positions of top of bins
while "x" != readline() >= ""   # x-Enter: exit, {keys..}Enter: next ball
    global r,c,d = 0,14,0
    t = Timer(drawball, 0, interval=0.1)
    while r < 15 sleep(0.01) end
    print("\e[40;1H")           # move cursor far down
end
