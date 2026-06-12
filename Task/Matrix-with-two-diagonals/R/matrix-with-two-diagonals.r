two_diagonal_matrix<-function(n){
res<-diag(nrow=n)
res[n-0:(n-1)+(0:(n-1))*n]<-1
res}

print(two_diagonal_matrix(6))
print(two_diagonal_matrix(7))

