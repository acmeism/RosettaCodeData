area <- function(a, b, c) {
    s = (a + b + c) / 2
    a2 = s*(s-a)*(s-b)*(s-c)
    if (a2>0) sqrt(a2) else 0
}

is.heronian <- function(a, b, c) {
    h = area(a, b, c)
    h > 0 && 0==h%%1
}

# borrowed from stackoverflow http://stackoverflow.com/questions/21502181/finding-the-gcd-without-looping-r
gcd <- function(x,y) {
  r <- x%%y;
  ifelse(r, gcd(y, r), y)
}

gcd3 <- function(x, y, z) {
    gcd(gcd(x, y), z)
}

maxside = 200
r <- NULL
for(c in 1:maxside){
    for(b in 1:c){
        for(a in 1:b){
            if(1==gcd3(a, b, c) && is.heronian(a, b, c)) {
                r <- rbind(r,c(a=a, b=b, c=c, perimeter=a+b+c, area=area(a,b,c)))
            }
        }
    }
}

cat("There are ",nrow(r)," Heronian triangles up to a maximal side length of ",maxside,".\n", sep="")
cat("Showing the first ten ordered first by perimeter, then by area:\n")
print(head(r[order(x=r[,"perimeter"],y=r[,"area"]),],n=10))
