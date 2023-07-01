HofN <- function(n) sum(1/seq_len(n)) #Task 1
H <- sapply(1:100000, HofN)
print(H[1:20]) #Task 2
print(sapply(1:10, function(x) which.max(H > x))) #Task 3 and stretch
