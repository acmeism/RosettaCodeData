# Project : Determine if only one instance is running

task = "ringw.exe"
taskname = "tasklist.txt"
remove(taskname)
system("tasklist >> tasklist.txt")
fp = fopen(taskname,"r")
tasks = read("tasklist.txt")
counttask = count(tasks,task)
if counttask > 0
   see task + " running in " + counttask + " instances" + nl
else
   see task + " is not running" + nl
ok

func count(cString,dString)
     sum = 0
     while substr(cString,dString) > 0
           sum++
           cString = substr(cString,substr(cString,dString)+len(string(sum)))
     end
     return sum
