#Creating an array
arr <- array(1:120, dim=c(5, 4, 3, 2))
#Setting and accessing a single element
arr[1, 1, 1, 1] <- 1000
arr[1, 1, 1, 1]
#Accessing a range of elements (leaving an index blank means you access all elements in that dimension)
arr[3:5,1,2,]
#Reshaping
dim(arr) <- c(2, 3, 4, 5)
#Adding dimensions to a vector
x <- 1:16
dim(x) <- rep(2, 4)
