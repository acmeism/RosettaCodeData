minproddigsum(n) = findfirst(i -> sum(digits(n * i)) == n, 1:typemax(Int32))

for j in 1:70
    print(lpad(minproddigsum(j), 10), j % 7 == 0 ? "\n" : "")
end
