fairshare(nplayers,len) = [sum(digits(n, base=nplayers)) % nplayers for n in 0:len-1]

for n in [2, 3, 5, 11]
    println("Fairshare ", n > 2 ? "among" : "between", " $n people: ", fairshare(n, 25))
end
