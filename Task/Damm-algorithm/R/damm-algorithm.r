Damm_algo <- function(number){
  row_i = 0

  iterable = strsplit(toString(number), "")[[1]]

  validation_matrix =
    matrix(
      c(
        0, 3, 1, 7, 5, 9, 8, 6, 4, 2,
        7, 0, 9, 2, 1, 5, 4, 8, 6, 3,
        4, 2, 0, 6, 8, 7, 1, 3, 5, 9,
        1, 7, 5, 0, 9, 8, 3, 4, 2, 6,
        6, 1, 2, 3, 0, 4, 5, 9, 7, 8,
        3, 6, 7, 4, 2, 0, 9, 5, 8, 1,
        5, 8, 6, 9, 7, 2, 0, 1, 3, 4,
        8, 9, 4, 5, 3, 6, 2, 0, 1, 7,
        9, 4, 3, 8, 6, 1, 7, 2, 0, 5,
        2, 5, 8, 1, 4, 3, 6, 7, 9, 0),
      nrow = 10, ncol = 10, byrow = T
    )

  for(digit in as.integer(iterable)){
    row_i = validation_matrix[row_i + 1, digit + 1]    #in R indexes start from 1 and not from zero
  }

  test <- ifelse(row_i == 0, "VALID", "NOT VALID")
  message(paste("Number", number, "is", test))
}

for(number in c(5724, 5727, 112946, 112949)){
Damm_algo(number)
  }
