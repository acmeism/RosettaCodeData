using Dates

fname, _ = mktemp()

println("The modification time of $fname is ", Dates.unix2datetime(mtime(fname)))
println("\nTouch this file.")
touch(fname)
println("The modification time of $fname is now ", Dates.unix2datetime(mtime(fname)))
