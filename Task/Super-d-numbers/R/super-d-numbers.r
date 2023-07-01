library(Rmpfr)
options(scipen = 999)

find_super_d_number <- function(d, N = 10){

  super_number <- c(NA)
  n = 0
  n_found = 0

  while(length(super_number) < N){

    n = n + 1
    test = d * mpfr(n, precBits = 200) ** d   #Here I augment precision
    test_formatted = .mpfr2str(test)$str      #and I extract the string from S4 class object

    iterable = strsplit(test_formatted, "")[[1]]

    if (length(iterable) < d) next

    for(i in d:length(iterable)){
      if (iterable[i] != d) next
      equalities = 0

      for(j in 1:d) {
        if (i == j) break

        if(iterable[i] == iterable[i-j])
          equalities = equalities + 1
        else break
      }

      if (equalities >= (d-1)) {
        n_found = n_found + 1
        super_number[n_found] = n
        break
      }
    }
  }

  message(paste0("First ", N, " super-", d, " numbers:"))
  print((super_number))

  return(super_number)
}

for(d in 2:6){find_super_d_number(d, N = 10)}
