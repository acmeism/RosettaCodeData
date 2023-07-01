library(RCurl)
webpage <- getURL("http://rosettacode.org")

#If you are linking to a page that no longer exists and need to follow the redirect, use followlocation=TRUE
webpage <- getURL("http://www.rosettacode.org", .opts=list(followlocation=TRUE))

#If you are behind a proxy server, you will need to use something like:
webpage <- getURL("http://rosettacode.org",
   .opts=list(proxy="123.123.123.123", proxyusername="domain\\username", proxypassword="mypassword", proxyport=8080))
#Don't forget that backslashes in your username or password need to be escaped!
