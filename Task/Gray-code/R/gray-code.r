GrayEncode <- function(binary) {
	gray <- substr(binary,1,1)
	repeat {
	if  (substr(binary,1,1) != substr(binary,2,2)) gray <- paste(gray,"1",sep="")
	else gray <- paste(gray,"0",sep="")
	binary <- substr(binary,2,nchar(binary))
	if (nchar(binary) <=1) {
		break
		}
	}
return (gray)
}
GrayDecode <- function(gray) {
	binary <- substr(gray,1,1)
	repeat {
	if  (substr(binary,nchar(binary),nchar(binary)) != substr(gray,2,2)) binary <- paste(binary ,"1",sep="")
	else binary <- paste(binary ,"0",sep="")
	gray <- substr(gray,2,nchar(gray))

	if (nchar(gray) <=1) {
		break
		}
	}
return (binary)
}
