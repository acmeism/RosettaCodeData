phi <- c(1, 1+1/1)

while (abs(phi[length(phi)]-phi[length(phi)-1])>10**-5){
phi <- c(phi, 1+1/phi[length(phi)])
}

print(paste("Result : ", phi[length(phi)], " after ", length(phi)-1 , "iterations."))
print(paste("Error is approximately : ", phi[length(phi)]-(1+sqrt(5))/2 ))
