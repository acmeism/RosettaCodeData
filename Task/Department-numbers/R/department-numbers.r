allPermutations <- setNames(expand.grid(seq(2, 7, by = 2), 1:7, 1:7), c("Police", "Sanitation", "Fire"))
solution <- allPermutations[which(rowSums(allPermutations)==12 & apply(allPermutations, 1, function(x) !any(duplicated(x)))),]
solution <- solution[order(solution$Police, solution$Sanitation),]
row.names(solution) <- paste0("Solution #", seq_len(nrow(solution)), ":")
print(solution)
