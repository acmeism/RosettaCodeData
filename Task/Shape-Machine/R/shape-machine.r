x <- readline("Enter any real number: ") |> as.numeric()
iters <- 0
repeat{
  x_new <- 0.86*(x+3)
  delta <- abs(x_new-x)
  iters <- iters+1
  if(delta < 10^(-15)){
    print(x_new, digits=17)
    cat(iters, "iterations before convergence")
    break
  }
  x <- x_new
}
