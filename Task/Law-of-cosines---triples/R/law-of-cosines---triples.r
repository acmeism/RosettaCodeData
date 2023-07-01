inputs <- cbind(combn(1:13, 2), rbind(seq_len(13), seq_len(13)))
inputs <- cbind(A = inputs[1, ], B = inputs[2, ])[sort.list(inputs[1, ]),]
Pythagoras <- inputs[, "A"]^2 + inputs[, "B"]^2
AtimesB <- inputs[, "A"] * inputs[, "B"]
CValues <- sqrt(cbind("C (90º)" = Pythagoras,
                      "C (60º)" = Pythagoras - AtimesB,
                      "C (120º)" = Pythagoras + AtimesB))
CValues[!t(apply(CValues, MARGIN = 1, function(x) x %in% 1:13))] <- NA
output <- cbind(inputs, CValues)[!apply(CValues, MARGIN = 1, function(x) all(is.na(x))),]
rownames(output) <- paste0("Solution ", seq_len(nrow(output)), ":")
print(output, na.print = "")
cat("There are",
    sum(!is.na(output[, 3])), "solutions in the 90º case,",
    sum(!is.na(output[, 4])), "solutions in the 60º case, and",
    sum(!is.na(output[, 5])), "solutions in the 120º case.")
