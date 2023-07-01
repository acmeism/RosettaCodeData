m <- 10
n <- 10
mat <- matrix(sample(1:20L, m*n, replace=TRUE), nrow=m); mat
done <- FALSE
for(i in seq_len(m))
{
   for(j in seq_len(n))
   {
      cat(mat[i,j])
      if(mat[i,j] == 20)
      {
         done <- TRUE
         break
      }
      cat(", ")
   }
   if(done)
   {
      cat("\n")
      break
   }
}
