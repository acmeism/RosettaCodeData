function processfixedlengthrecords(infname, blocksize, outfname)
    inf = open(infname)
    outf = open(outfname, "w")
    filedata = [ read(inf, blocksize) for _ in 1:10 ]

    for line in filedata
        s = join([Char(c) for c in line], "")
        @assert(length(s) == blocksize)
        write(outf, s)
    end
end

processfixedlengthrecords("infile.dat", 80, "outfile.dat")
