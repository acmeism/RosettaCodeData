get.top.N.salaries <- function(N)
{
   with(dfr, tapply(Salary, Department,
      function(x)
      {
         sort(x);
         lx <- length(x)
         if(N >= lx) return(x)
         x[-1:(N-lx)]
      }))
}

get.top.N.salaries(3)
