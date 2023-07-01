library(RCurl)
webpage <- getURL("https://sourceforge.net/", .opts=list(followlocation=TRUE, ssl.verifyhost=FALSE, ssl.verifypeer=FALSE))
