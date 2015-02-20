#open file for reading
set myfile [open "README.TXT" r]
#read something from the file
gets $myfile mydata
#show what was read from the file
#should print "This is line1, so hello world...."
puts $mydata
#close the file
close $myfile
