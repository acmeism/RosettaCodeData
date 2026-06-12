import os
targetfile = "pycon-china"
os.rename(os.path.realpath(targetfile), os.path.realpath(targetfile)+".bak")
f = open(os.path.realpath(targetfile), "w")
f.write("this task was solved during a talk about rosettacode at the PyCon China in 2011")
f.close()
