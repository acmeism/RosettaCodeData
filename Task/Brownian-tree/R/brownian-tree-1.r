# plotmat(): Simple plotting using a square matrix mat (filled with 0/1). v. 8/31/16
# Where: mat - matrix; fn - file name; clr - color; ttl - plot title;
#        dflg - writing dump file flag (0-no/1-yes): psz - picture size.
plotmat <- function(mat, fn, clr, ttl, dflg=0, psz=600) {
  m <- nrow(mat); d <- 0;
  X=NULL; Y=NULL;
  pf = paste0(fn, ".png"); df = paste0(fn, ".dmp");
  for (i in 1:m) {
    for (j in 1:m) {if(mat[i,j]==0){next} else {d=d+1; X[d] <- i; Y[d] <- j;} }
  };
  cat(" *** Matrix(", m,"x",m,")", d, "DOTS\n");
  # Dumping if requested (dflg=1).
  if (dflg==1) {dump(c("X","Y"), df); cat(" *** Dump file:", df, "\n")};
  # Plotting
  plot(X,Y, main=ttl, axes=FALSE, xlab="", ylab="", col=clr, pch=20);
  dev.copy(png, filename=pf, width=psz, height=psz);
  # Cleaning
  dev.off(); graphics.off();
}

# plotv2(): Simple plotting using 2 vectors (dumped into ".dmp" file by plotmat()).
# Where: fn - file name; clr - color; ttl - plot title; psz - picture size.
# v. 8/31/16
plotv2 <- function(fn, clr, ttl, psz=600) {
  cat(" *** START:", date(), "clr=", clr, "psz=", psz, "\n");
  cat(" *** File name -", fn, "\n");
  pf = paste0(fn, ".png"); df = paste0(fn, ".dmp");
  source(df);
  d <- length(X);
  cat(" *** Source dump-file:", df, d, "DOTS\n");
  cat(" *** Plot file -", pf, "\n");
  # Plotting
  plot(X, Y, main=ttl, axes=FALSE, xlab="", ylab="", col=clr, pch=20);
  # Writing png-file
  dev.copy(png, filename=pf, width=psz, height=psz);
  # Cleaning
  dev.off(); graphics.off();
  cat(" *** END:", date(), "\n");
}
