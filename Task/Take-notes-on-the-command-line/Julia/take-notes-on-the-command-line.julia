using Dates

const filename = "NOTES.TXT"

if length(ARGS) == 0
    fp = open(filename, "r")
    println(read(fp, String))
else
    fp = open(filename, "a+")
    write(fp, string(DateTime(now()), "\n\t", join(ARGS, " "), "\n"))
end
close(fp)
