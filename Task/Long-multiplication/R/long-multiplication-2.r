longmult <- function(xstr, ystr)
{
   #get the number described in each string
   getnumeric <- function(xstr) as.numeric(unlist(strsplit(xstr, "")))

   x <- getnumeric(xstr)
   y <- getnumeric(ystr)

   #multiply each pair of digits together
   mat <- apply(x %o% y, 1, as.character)

   #loop over columns, then rows, adding zeroes to end of each number in the matrix to get the correct positioning
   ncols <- ncol(mat)
   cols <- seq_len(ncols)
   for(j in cols)
   {
      zeroes <- paste(rep("0", ncols-j), collapse="")
      mat[,j] <- paste(mat[,j], zeroes, sep="")
   }

   nrows <- nrow(mat)
   rows <- seq_len(nrows)
   for(i in rows)
   {
      zeroes <- paste(rep("0", nrows-i), collapse="")
      mat[i,] <- paste(mat[i,], zeroes, sep="")
   }

   #add zeroes to the start of the each number, so they are all the same length
   len <- max(nchar(mat))
   strcolumns <- formatC(cbind(as.vector(mat)), width=len)
   strcolumns <- gsub(" ", "0", strcolumns)

   #line up all the numbers below each other
   strmat <- matrix(unlist(strsplit(strcolumns, "")), byrow=TRUE, ncol=len)

   #convert to numeric and add them
   mat2 <- apply(strmat, 2, as.numeric)
   sum1 <- colSums(mat2)

   #repeat the process on each of the totals, until each total is a single digit
   repeat
   {
      ntotals <- length(sum1)
      totals <- seq_len(ntotals)
      for(i in totals)
      {
         zeroes <- paste(rep("0", ntotals-i), collapse="")
         sum1[i] <- paste(sum1[i], zeroes, sep="")
      }
      len2 <- max(nchar(sum1))
      strcolumns2 <- formatC(cbind(as.vector(sum1)), width=len2)
      strcolumns2 <- gsub(" ", "0", strcolumns2)
      strmat2 <- matrix(unlist(strsplit(strcolumns2, "")), byrow=TRUE, ncol=len2)
      mat3 <- apply(strmat2, 2, as.numeric)
      sum1 <- colSums(mat3)
      if(all(sum1 < 10)) break
   }

   #Concatenate the digits together
   ans <- paste(sum1, collapse="")
   ans
}

a <- "18446744073709551616"
longmult(a, a)
