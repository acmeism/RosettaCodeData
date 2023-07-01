# provided by neonira

integerToText <- function(value_n_1) {
  english_words_for_numbers <- list(
    simples = c(
      'zero', 'one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine',
      'ten', 'eleven', 'twelve', 'thirteen', 'fourteen', 'fifteen', 'sixteen', 'seventeen', 'eighteen', 'nineteen'
    ),
    tens = c('twenty', 'thirty', 'forty', 'fifty', 'sixty', 'seventy', 'eighty', 'ninety'),
    powers = c(
      'hundred'     = 100,
      'thousand'    = 1000,
      'million'     = 1000000,
      'billion'     = 1000000000,
      'trillion'    = 1000000000000,
      'quadrillion' = 1000000000000000,
      'quintillion' = 1000000000000000000
    )
  )

  buildResult <- function(x_s) {
    if (value_n_1 < 0) return(paste('minus', x_s))
    x_s
  }
  withDash <- function(a_s, b_s) paste(a_s, b_s, sep = '-')
  val <- abs(value_n_1)
  if (val < 20L) return(buildResult(english_words_for_numbers$simples[val + 1L]))
  if (val < 100L) {
    tens <- val %/% 10L - 1L
    reminder <- val %% 10L
    if (reminder == 0L) return(buildResult(english_words_for_numbers$ten[tens]))
    return(buildResult(withDash(english_words_for_numbers$ten[tens], Recall(reminder))))
  }

  index <- l <- length(english_words_for_numbers$powers)
  for(power in seq_len(l)) {
    if (val < english_words_for_numbers$powers[power]) {
      index <- power - 1L
      break
    }
  }

  f <- Recall(val %/% english_words_for_numbers$powers[index])
  reminder <- val %% english_words_for_numbers$powers[index]
  if (reminder == 0L) return(buildResult(paste(f, names(english_words_for_numbers$powers)[index])))
  buildResult(paste(f, names(english_words_for_numbers$powers)[index],  Recall(reminder)))
}

magic <- function(value_n_1) {
  text <- vector('character')
  while(TRUE) {
    r <- integerToText(value_n_1)
    nc <- nchar(r)
    complement <- ifelse(value_n_1 == 4L, "is magic", paste("is", integerToText(nc)))
    text[length(text) + 1L] <- paste(r, complement)
    if (value_n_1 == 4L) break
    value_n_1 <- nc
  }

  buildSentence <- function(x_s) paste0(toupper(substr(x_s, 1L, 1L)), substring(x_s, 2L), '.')
  buildSentence(paste(text, collapse = ', '))
}
