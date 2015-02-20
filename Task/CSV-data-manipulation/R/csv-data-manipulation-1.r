df <- read.csv(textConnection(
"C1,C2,C3,C4,C5
1,5,9,13,17
2,6,10,14,18
3,7,11,15,19
4,8,12,16,20"))

df <- transform(df,SUM = rowSums(df))

write.csv(df,row.names = FALSE)
