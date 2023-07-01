# A task
foo <- function()
{
   for(i in 1:10)
   {
      mat <- matrix(rnorm(1e6), nrow=1e3)
      mat^-0.5
   }
}
# Time the task
timer <- system.time(foo())
# Extract the processing time
timer["user.self"]
