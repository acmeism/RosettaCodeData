#open file for writing
set myfile [open "README.TXT" w]
#write something to the file
puts $myfile "This is line 1, so hello world...."
#close the file
close $myfile
