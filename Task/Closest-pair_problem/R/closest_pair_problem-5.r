closest.pairs.bruteforce <- function(x, y=NULL)
{
	if (!is.null(y))
	{
		x <- cbind(x,y)
	}
	d <- dist(x)
	cp <- x[combn(1:nrow(x), 2)[, which.min(d)],]
	list(p1=cp[1,], p2=cp[2,], d=min(d))
}

closest.pairs.dandc <- function(x, y=NULL)
{
	if (!is.null(y))
	{
		x <- cbind(x,y)
	}
	if (sd(x[,"x"]) < sd(x[,"y"]))
	{
		x <- cbind(x=x[,"y"],y=x[,"x"])
		swap <- TRUE
	}
	else
	{
		swap <- FALSE
	}
	xp <- x[order(x[,"x"]),]
	.cpdandc.rec <- function(xp,yp)
	{
		n <- dim(xp)[1]
		if (n <= 4)
		{
			closest.pairs.bruteforce(xp)
		}
		else
		{
			xl <- xp[1:floor(n/2),]
			xr <- xp[(floor(n/2)+1):n,]
			cpl <- .cpdandc.rec(xl)
			cpr <- .cpdandc.rec(xr)
			if (cpl$d<cpr$d) cp <- cpl else cp <- cpr
			cp
		}
	}
	cp <- .cpdandc.rec(xp)
	
	yp <- x[order(x[,"y"]),]
	xm <- xp[floor(dim(xp)[1]/2),"x"]
	ys <- yp[which(abs(xm - yp[,"x"]) <= cp$d),]
	nys <- dim(ys)[1]
	if (!is.null(nys) && nys > 1)
	{
		for (i in 1:(nys-1))
		{
			k <- i + 1
			while (k <= nys && ys[i,"y"] - ys[k,"y"] < cp$d)
			{
				d <- sqrt((ys[k,"x"]-ys[i,"x"])^2 + (ys[k,"y"]-ys[i,"y"])^2)
				if (d < cp$d) cp <- list(p1=ys[i,],p2=ys[k,],d=d)
				k <- k + 1
			}
		}
	}
	if (swap)
	{
		list(p1=cbind(x=cp$p1["y"],y=cp$p1["x"]),p2=cbind(x=cp$p2["y"],y=cp$p2["x"]),d=cp$d)
	}
	else
	{
		cp
	}
}

# Test functions
cat("How many points?\n")
n <- scan(what=integer(),n=1)
x <- rnorm(n)
y <- rnorm(n)
tstart <- proc.time()[3]
cat("Closest pairs divide and conquer:\n")
print(cp <- closest.pairs.dandc(x,y))
cat(sprintf("That took %.2f seconds.\n",proc.time()[3] - tstart))
plot(x,y)
points(c(cp$p1["x"],cp$p2["x"]),c(cp$p1["y"],cp$p2["y"]),col="red")
tstart <- proc.time()[3]
cat("\nClosest pairs brute force:\n")
print(closest.pairs.bruteforce(x,y))
cat(sprintf("That took %.2f seconds.\n",proc.time()[3] - tstart))
