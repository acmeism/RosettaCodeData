out = open("out.txt", "w")
for line in split(strip(read("in.txt", String)), "\n")
    fielda, fieldb, fieldd = line[1:5], line[6:10], line[16:20]
    fieldc = lpad((line[15] == '-' ? -1 : 1) * parse(Int, line[11:14]), 5)
    print(out, fielda, fieldc, 'X'^length(fieldd), "\n")
end
