def v(n) n.digits(2).index(1)%2 end
vile = (1..1024).select{|n|v(n)==0}
dopey = (1..1024).select{|n|v(n)!=0}
puts vile.slice(0,25).to_s
puts dopey.slice(0,25).to_s
for i in (1..10) do
    print 1<<i,":"
    print vile.take_while{|n|n<=1<<i}.size
    print " "
    print dopey.take_while{|n|n<=1<<i}.size
    puts
end
