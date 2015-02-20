result = amb({{'the','that','a'},{'frog','elephant','thing'},{'walked','treaded','grows'},{'slowly','quickly'}})
for i,v in next,result do
    io.write (i,':\t')
    for j,u in next,v do
        io.write (u,' ')
    end
    io.write ('\n')
end
