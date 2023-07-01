for line in eachline("data/fasta.txt")
    if startswith(line, '>')
        print(STDOUT, "\n$(line[2:end]): ")
    else
        print(STDOUT, "$line")
    end
end
