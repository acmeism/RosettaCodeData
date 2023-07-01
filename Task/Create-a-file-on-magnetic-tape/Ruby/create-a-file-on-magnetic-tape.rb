File.open("tape.file", "w") do |fh|
    fh.syswrite("This code should be able to write a file to magnetic tape.\n")
end
