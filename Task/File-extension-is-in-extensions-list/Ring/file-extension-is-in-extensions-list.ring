# Project : File extension is in extensions list

extensions = [".zip", ".rar", ".7z", ".gz", ".archive", ".a##", ".tar.bz2"]

filenames = ["MyData.a##", "MyData.tar.gz", "MyData.gzip", "MyData.7z.backup",
                   "MyData...", "MyData", "MyData_v1.0.tar.bz2", "MyData_v1.0.bz2"]

for n = 1 to len(filenames)
    flag = 0
    for m = 1 to len(extensions)
        if right(filenames[n], len(extensions[m])) = extensions[m]
           flag = 1
           see filenames[n] + " -> " + extensions[m] + " -> " + " true" + nl
           exit
        ok
    next
    if flag = 0
       see filenames[n] + " -> " + "false" + nl
    ok
next
