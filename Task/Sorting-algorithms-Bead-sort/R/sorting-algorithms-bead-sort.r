gen_abacus <- function(v){
  nmax <- max(v)
  gen_col <- function(n) c(rep(1, n), rep(0, nmax-n))
  sapply(v, gen_col)
}

beadsort <- function(v){
  flip <- function(v) gen_abacus(v) |> apply(1, sum)
  v |> flip() |> flip() |> rev()
}

beadsort(c(2, 4, 1, 3, 3))
