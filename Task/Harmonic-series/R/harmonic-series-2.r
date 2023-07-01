firstNHarmonicNumbers <- function(n) cumsum(1/seq_len(n)) #Task 1
H <- firstNHarmonicNumbers(100000) #Runs stunningly quick
print(H[1:20]) #Task 2
print(sapply(1:10, function(x) which.max(H > x))) #Task 3 and stretch
