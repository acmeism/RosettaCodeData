numdigits <- function(n) ifelse(log10(n)%%1==0,
                                1+log10(n),
                                ceiling(log10(n)))

digmul <- function(n){
  k <- numdigits(n)
  get_digit <- function(m) (n%/%10^m)%%10
  prod(sapply(0:(k-1), get_digit))
}

mdr_mp <- function(n){
  m <- n
  i <- 0
  while(m > 9){
    m <- digmul(m)
    i <- i+1
  }
  c("MDR"=m, "MP"=i)
}

test_nums <- c(123321, 7739, 893, 899998)
rbind("n"=test_nums, sapply(test_nums, mdr_mp)) |> t()

first5mdr <- function(n){
  m <- 0
  nums <- numeric(0)
  while(length(nums) < 5){
    if(mdr_mp(m)[1] == n){
      nums <- c(nums, m)
    }
    m <- m+1
  }
  setNames(nums, paste0("n_", 1:5))
}

rbind("MDR"=0:9, sapply(0:9, first5mdr)) |> t()
