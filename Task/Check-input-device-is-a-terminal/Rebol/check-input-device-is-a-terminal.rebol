either system/options/flags/cgi [
    print "CGI mode - no terminal"
    ;; get input data
    probe data: read system/ports/input
][  print "not CGI mode" ]
