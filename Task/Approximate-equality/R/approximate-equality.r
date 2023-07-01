approxEq <- function(...) isTRUE(all.equal(...))
tests <- rbind(c(100000000000000.01, 100000000000000.011),
             c(100.01, 100.011),
             c(10000000000000.001 / 10000.0, 1000000000.0000001000),
             c(0.001, 0.0010000001),
             c(0.000000000000000000000101, 0.0),
             c(sqrt(2) * sqrt(2), 2.0),
             c(-sqrt(2) * sqrt(2), -2.0),
             c(3.14159265358979323846, 3.14159265358979324))
results <- mapply(approxEq, tests[, 1], tests[, 2])
#All that remains is to print out our results in a presentable way:
printableTests <- format(tests, scientific = FALSE)
print(data.frame(x = printableTests[, 1], y = printableTests[, 2], Equal = results, row.names = paste0("Test ", 1:8, ": ")))
