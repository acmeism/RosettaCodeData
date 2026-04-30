is_squarefree <- function(n){
  limit <- floor(sqrt(n))
  squares <- if(limit>1) (2:limit)^2 else 4
  !(0 %in% (n%%squares))
}

list_squarefree <- function(n1, n2) Filter(is_squarefree, n1:n2)

list_squarefree(1, 145)
print(list_squarefree(10^12, 145+10^12), digits=13)

count_squarefree <- function(n1, n2) length(list_squarefree(n1, n2))
test_ranges <- lapply(2:6, function(n) list(1, 10^n))
sapply(test_ranges, function(l) do.call(count_squarefree, l))
