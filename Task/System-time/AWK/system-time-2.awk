function dos_date(  cmd,d,t,x) { 	# under MS Windows
#   cmd = "DATE /T"
#   cmd | getline d	# Format depends on locale, e.g. MM/DD/YYYY or YYYY-MM-DD
#   close(cmd)        	# close pipe
# ##print d
#   cmd = "TIME /T"
#   cmd | getline t   	# 13:59
#   close(cmd) 		
# ##print t
#   return d t

    cmd = "echo %DATE% %TIME%"		# this gives better time-resolution
    cmd | getline x   			# 2014-10-31 20:57:36.84
    close(cmd)
    return x
}
BEGIN {
   print "Date and time:", dos_date()
  #print systime(), strftime()		# gawk only
}
