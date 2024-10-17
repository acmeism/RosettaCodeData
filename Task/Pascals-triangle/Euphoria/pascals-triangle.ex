sequence row
row = {}
for m = 1 to 10 do
    row = row & 1
    for n = length(row)-1 to 2 by -1 do
        row[n] += row[n-1]
    end for
    print(1,row)
    puts(1,'\n')
end for
