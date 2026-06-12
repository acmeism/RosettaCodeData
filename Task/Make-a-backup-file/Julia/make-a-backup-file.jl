targetfile = "pycon-china"
mv(realpath(targetfile), realpath(targetfile) * ".bak")
# "a+" for permissions of reading, writing, creating
open(targetfile, "w+") do io
    println(io, "this task was solved during a talk about rosettacode at the PyCon China in 2011")
end
