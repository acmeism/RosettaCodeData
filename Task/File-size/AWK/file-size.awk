# usage:  awk -f filesize.awk -v fn=input.txt

BEGIN { 		# Filesize on Unix, using ls
  #system("ls -l")

   if(!fn) fn ="input.txt"
   cmd="ls -l " fn
   print "#", cmd
   system(cmd)

   cmd | getline x
   close(cmd)
  #print x
   n=split(x,stat," ")
  #for (i in stat) {print i, stat[i] }
   print "file:", stat[9], "size:", stat[5]
}
