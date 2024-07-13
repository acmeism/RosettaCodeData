conjugate_transpose<- function(M){
  t(Conj(M))}

is_hermitian <- function(M,eps=10**-10){
  all(abs(M-conjugate_transpose(M))<eps)
}

is_normal <-function(M,eps=10**-10){
  conjugate <- conjugate_transpose(M)
 all(abs(M%*%conjugate- conjugate%*%M)<eps)
}

is_unitary  <-function(M,eps=10**-10){
 all(abs(M%*% conjugate_transpose(M)-diag(nrow(M)))<eps)
}

M1 = matrix(c(3+0i,2-1i,
              2+1i,1+0i),nrow=2)
cat("M1")
cat("\n")
print(M1)
cat("\n")
Conj_M1 = conjugate_transpose(M1)
cat("Conjugate transpose of M1")
cat("\n")
print(Conj_M1)
cat(paste0("Hermitian ? ", is_hermitian(M1)))
cat("\n")
cat(paste0("Normal ? ", is_normal(M1)))
cat("\n")
cat(paste0("Unitary ? ", is_unitary(M1)))


M2 = matrix(c(1+0i,0+0i,1+0i,
              1+0i,1+0i,0+0i,
              0+0i,1+0i,1+0i),nrow=3)
cat("\n")
cat("M2")
cat("\n")
print(M2)
cat("\n")
Conj_M2 = conjugate_transpose(M2)
cat("Conjugate transpose of M2")
cat("\n")
print(Conj_M2)
cat(paste0("Hermitian ? ", is_hermitian(M2)))
cat("\n")
cat(paste0("Normal ? ", is_normal(M2)))
cat("\n")
cat(paste0("Unitary ? ", is_unitary(M2)))


M3 = matrix(c(sqrt(2)/2+0i,0-(sqrt(2)/2)*1i,0+0i,
              sqrt(2)/2+0i,0+(sqrt(2)/2)*1i,0+0i,
              0+0i,0+0i,0+1i),ncol=3)
cat("\n")
cat("M3")
cat("\n")
print(M3)
cat("\n")
Conj_M3 = conjugate_transpose(M3)
cat("Conjugate transpose of M3")
cat("\n")
print(Conj_M3)
cat(paste0("Hermitian ? ", is_hermitian(M3)))
cat("\n")
cat(paste0("Normal ? ", is_normal(M3)))
cat("\n")
cat(paste0("Unitary ? ", is_unitary(M3)))
