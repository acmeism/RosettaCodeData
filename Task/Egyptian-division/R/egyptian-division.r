Egyptian_division <- function(num, den){
  pow2 = 0
  row = 1

  Table = data.frame(powers_of_2 = 2^pow2,
                     doubling = den)

  while(Table$doubling[nrow(Table)] < num){
    row = row + 1
    pow2 = pow2 + 1

    Table[row, 1] <- 2^pow2
    Table[row, 2] <- 2^pow2 * den
  }

  Table <- Table[-nrow(Table),]
  #print(Table) to see the table

  answer <- 0
  accumulator <- 0

  for (i in nrow(Table):1) {
    if (accumulator + Table$doubling[i] <= num) {
      accumulator <- accumulator + Table$doubling[i]
      answer <- answer + Table$powers_of_2[i]
    }
  }

  remainder = abs(accumulator - num)

  message(paste0("Answer is ", answer, ", remainder ", remainder))

  }

Egyptian_division(580, 34)
Egyptian_division(300, 2)
