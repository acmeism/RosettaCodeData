## Stern-Brocot sequence
## 12/19/16 aev
SternBrocot <- function(n){
  V <- 1; k <- n/2;
  for (i in 1:k)
    { V[2*i] = V[i]; V[2*i+1] = V[i] + V[i+1];}
  return(V);
}

## Required tests:
require(pracma);
{
cat(" *** The first 15:",SternBrocot(15),"\n");
cat(" *** The first i@n:","\n");
V=SternBrocot(40);
for (i in 1:10) {j=match(i,V); cat(i,"@",j,",")}
V=SternBrocot(1200);
i=100; j=match(i,V); cat(i,"@",j,"\n");
V=SternBrocot(1000); j=1;
for (i in 2:1000) {j=j*gcd(V[i-1],V[i])}
if(j==1) {cat(" *** All GCDs=1!\n")} else {cat(" *** All GCDs!=1??\n")}
}
