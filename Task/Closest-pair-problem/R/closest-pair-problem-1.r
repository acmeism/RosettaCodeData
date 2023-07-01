closest_pair_brute <-function(x,y,plotxy=F) {
    xy = cbind(x,y)
    cp = bruteforce(xy)
    cat("\n\nShortest path found = \n From:\t\t(",cp[1],',',cp[2],")\n To:\t\t(",cp[3],',',cp[4],")\n Distance:\t",cp[5],"\n\n",sep="")
    if(plotxy) {
        plot(x,y,pch=19,col='black',main="Closest Pair", asp=1)
        points(cp[1],cp[2],pch=19,col='red')
        points(cp[3],cp[4],pch=19,col='red')
    }
    distance <- function(p1,p2) {
        x1 = (p1[1])
        y1 = (p1[2])
        x2 = (p2[1])
        y2 = (p2[2])
        sqrt((x2-x1)^2 + (y2-y1)^2)
    }
    bf_iter <- function(m,p,idx=NA,d=NA,n=1) {
        dd = distance(p,m[n,])
        if((is.na(d) || dd<=d) && p!=m[n,]){d = dd; idx=n;}
        if(n == length(m[,1])) { c(m[idx,],d) }
        else bf_iter(m,p,idx,d,n+1)
    }
    bruteforce <- function(pmatrix,n=1,pd=c(NA,NA,NA,NA,NA)) {
        p = pmatrix[n,]
        ppd = c(p,bf_iter(pmatrix,p))
        if(ppd[5]<pd[5] || is.na(pd[5])) pd = ppd
        if(n==length(pmatrix[,1]))  pd
        else bruteforce(pmatrix,n+1,pd)
    }
}
