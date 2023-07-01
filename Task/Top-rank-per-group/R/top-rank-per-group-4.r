get.top.N.salaries2 <- function(N)
{
   #Sort data frame by Department, then by Salary
   sorted <- dfr[with(dfr, order(Department, Salary, decreasing=TRUE)),]
   #Split the dataframe up, by Department
   bydept <- split(sorted, sorted$Department)
   #Return the first N values (or all of them
   lapply(bydept,
      function(x)
      {
         n <- min(N, nrow(x))
         x[1:n,]
      })
}
get.top.N.salaries2(3)
